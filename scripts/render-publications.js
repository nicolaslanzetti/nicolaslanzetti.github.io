// Enhanced renderer: load canonical data and render into categorized lists.
(async function(){
  try {
    // wait for DOM so lists inserted in HTML are present even if the script is included early
    if (document.readyState === 'loading') {
      await new Promise(res => document.addEventListener('DOMContentLoaded', res, {once:true}));
    }
    let data = null;
    // first try inline JSON in the page (helps when opened via file://)
    const inline = document.getElementById('publications-data');
    if (inline) {
      try { data = JSON.parse(inline.textContent); } catch(e) { data = null; }
    }
    if (!data) {
      // fetch multiple files in parallel and merge
      const urls = ['data/preprints.json','data/journals.json',
        'data/cs_conferences.json','data/control_conferences.json','data/energy_transportation_conferences.json',
        'data/dissertations.json'];
      const promises = urls.map(u => fetch(u)
        .then(r => r.ok ? r.json() : Promise.reject(new Error('HTTP ' + r.status)))
        .catch(err => { console.warn('Failed to load', u, err); return []; }));
      const results = await Promise.all(promises);
      data = results.flat().filter(Boolean);
    }

    if (!data || data.length === 0) {
      const host = document.querySelector('main') || document.body;
      const note = document.createElement('p');
      note.textContent = 'Publications could not be loaded. If you opened this file directly from disk, view it through a local web server instead (e.g. run "python3 -m http.server" in the site folder, then open http://localhost:8000/publications.html).';
      note.style.color = '#B22222';
      host.insertBefore(note, host.firstChild);
      return;
    }

    const pre    = document.getElementById('preprints-list');
    const journal = document.getElementById('journal-list');
    const csconf  = document.getElementById('cs-conferences-list');
    const ctrlconf = document.getElementById('control-conferences-list');
    const etconf  = document.getElementById('energy-transportation-conferences-list');
    const diss    = document.getElementById('dissertations-list');
    if (!pre && !journal && !csconf && !ctrlconf && !etconf && !diss) return;
    if (pre)      pre.innerHTML      = '';
    if (journal)  journal.innerHTML  = '';
    if (csconf)   csconf.innerHTML   = '';
    if (ctrlconf) ctrlconf.innerHTML = '';
    if (etconf)   etconf.innerHTML   = '';
    if (diss)     diss.innerHTML     = '';

    function makeButton(kind, url) {
      const btn = document.createElement('button');
      btn.className = 'button';
      const icons = { paper: 'fa-file-pdf-o', code: 'fa-code', slides: 'fa-picture-o', video: 'fa-video-camera', bib: 'fa-quote-right' };
      const icon = icons[kind] || 'fa-link';
      btn.innerHTML = `<i class="fa ${icon}"></i> ${kind.charAt(0).toUpperCase()+kind.slice(1)}`;
      btn.onclick = () => {
        if (kind === 'bib') {
          const el = document.getElementById(btn.getAttribute('data-target'));
          if (el) el.style.display = (el.style.display === 'block' ? 'none' : 'block');
        } else {
          try { window.open(url, '_blank', 'noopener'); } catch(e) { window.location.href = url; }
        }
      };
      return btn;
    }

    function highlightOwner(text) {
      if (!text) return text;
      const ownerRegex = /\b(Nicolas Lanzetti|N\. Lanzetti|Lanzetti, N\.|Lanzetti, Nicolas)(\*?)/gi;
      return String(text).replace(ownerRegex, '<span class="owner-name">$1$2</span>');
    }

    data.forEach((p, idx) => {
      const li = document.createElement('li');
      li.style.margin = '10px 0px';

      const titleLink = p.url_title || p.url || '';
      const title = titleLink ? `<a href="${titleLink}" target="_blank" rel="noopener">${p.title}</a>` : p.title;
      let meta = `${p.authors || ''}`;
      if (p.venue || p.year) meta += `<br>${p.venue || ''}${p.year ? ', ' + p.year : ''}`;
      meta = highlightOwner(meta);

      const committeeHTML = p.committee
        ? `<br><em class="committee">Committee: ${Array.isArray(p.committee) ? p.committee.join(', ') : p.committee}</em>`
        : '';

      const container = document.createElement('div');
      const notesText = p.notes ? (Array.isArray(p.notes) ? p.notes.join(', ') : p.notes) : null;
      const notesHTML = notesText ? `<div class="notes" style="font-weight:700; margin-top:0">${notesText}</div>` : '';
      container.innerHTML = `<em>${title}</em><br>${meta}${notesHTML}${committeeHTML}`;

      const resources = document.createElement('div');
      resources.style.marginTop = '0';
      const paperUrl = p.url_paper || p.pdf || (p.url && p.url.includes('arxiv.org') ? p.url.replace('/abs/', '/pdf/') : null) || null;
      if (paperUrl) resources.appendChild(makeButton('paper', paperUrl));
      if (p.code)   resources.appendChild(makeButton('code',  p.code));
      if (p.slides) resources.appendChild(makeButton('slides', p.slides));
      if (p.video)  resources.appendChild(makeButton('video',  p.video));

      let pendingAbstract = null;

      const aid = `abstract-${idx}`;
      const abtn = document.createElement('button');
      abtn.className = 'button';
      abtn.innerHTML = `<i class="fa fa-align-left"></i> Abstract`;
      if (p.abstract) {
        abtn.onclick = () => {
          const el = document.getElementById(aid);
          if (el) el.style.display = (el.style.display === 'block' ? 'none' : 'block');
        };
        resources.appendChild(abtn);
        const abdiv = document.createElement('div');
        abdiv.className = 'boxabstract';
        abdiv.id = aid;
        abdiv.style.display = 'none';
        abdiv.innerHTML = p.abstract;
        pendingAbstract = abdiv;
      } else if (p.url) {
        abtn.onclick = () => {
          try { window.open(p.url, '_blank', 'noopener'); } catch(e) { window.location.href = p.url; }
        };
        resources.appendChild(abtn);
      }


      li.appendChild(container);
      li.appendChild(resources);
      if (pendingAbstract) li.appendChild(pendingAbstract);

      const appendTo = (el) => {
        if (el) el.appendChild(li);
        else if (pre) pre.appendChild(li);
        else if (journal) journal.appendChild(li);
        else document.body.appendChild(li);
      };

      if      (p.type === 'preprint')                        appendTo(pre);
      else if (p.type === 'journal')                         appendTo(journal);
      else if (p.type === 'cs_conference')                   appendTo(csconf || pre);
      else if (p.type === 'control_conference')              appendTo(ctrlconf || pre);
      else if (p.type === 'energy_transportation_conference') appendTo(etconf || pre);
      else if (p.type === 'dissertation')                    appendTo(diss || pre);
      else                                                   appendTo(pre);
    });
  } catch(e) {
    console.error('Failed to load publications data', e);
  }
})();

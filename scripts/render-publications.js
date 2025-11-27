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
  const urls = ['data/preprints.json','data/journals.json','data/conferences.json','data/others.json',
        'data/cs_conferences.json','data/dissertations.json','data/lecture_notes.json'];
      const promises = urls.map(u => fetch(u).then(r => r.ok ? r.json().catch(()=>[]) : []).catch(()=>[]));
      const results = await Promise.all(promises);
      // flatten and keep as data array
      data = results.flat().filter(Boolean);
    }

  const pre = document.getElementById('preprints-list');
  const journal = document.getElementById('journal-list');
  const csconf = document.getElementById('cs-conferences-list');
  const diss = document.getElementById('dissertations-list');
  const lnotes = document.getElementById('lecture-notes-list');
  // proceed if at least one target list exists
  if (!pre && !journal && !csconf && !diss && !lnotes) return;
  if (pre) pre.innerHTML = '';
  if (journal) journal.innerHTML = '';
  if (csconf) csconf.innerHTML = '';
  if (diss) diss.innerHTML = '';
  if (lnotes) lnotes.innerHTML = '';

    // small helper to create resource buttons
    function makeButton(kind, url) {
      const btn = document.createElement('button');
      btn.className = 'button';
      const icons = { paper: 'fa-file-pdf-o', code: 'fa-code', slides: 'fa-picture-o', video: 'fa-video-camera', abstract: 'fa-align-left', bib: 'fa-quote-right' };
      const icon = icons[kind] || 'fa-link';
      btn.innerHTML = `<i class="fa ${icon}"></i> ${kind.charAt(0).toUpperCase()+kind.slice(1)}`;
      btn.onclick = () => {
        if (kind === 'abstract' || kind === 'bib') {
          const id = btn.getAttribute('data-target');
          const el = document.getElementById(id);
          if (el) el.style.display = (el.style.display === 'block' ? 'none' : 'block');
        } else {
          try { window.open(url, '_blank', 'noopener'); } catch(e) { window.location.href = url; }
        }
      };
      return btn;
    }

    data.forEach((p, idx) => {
      const li = document.createElement('li');
      li.style.margin = '10px 0px';

  // title link: prefer url_title, fall back to url
  const titleLink = p.url_title || p.url || '';
  const title = titleLink ? `<a href="${titleLink}" target="_blank" rel="noopener">${p.title}</a>` : p.title;
  let meta = `${p.authors || ''}`;
  if (p.venue || p.year) meta += `<br>${p.venue || ''}${p.year ? ', ' + p.year : ''}`;

  // highlight the owner's name in the authors/meta (several common variants)
  function highlightOwner(text) {
    if (!text) return text;
    // match common variants and optional trailing asterisk
    const ownerRegex = /\b(Nicolas Lanzetti|N\. Lanzetti|Lanzetti, N\.|Lanzetti, Nicolas)(\*?)/gi;
    return String(text).replace(ownerRegex, '<span class="owner-name">$1$2</span>');
  }
  meta = highlightOwner(meta);

  // render committee for dissertations when present
  const committeeHTML = p.committee ? (Array.isArray(p.committee) ? `<br><em class="committee">Committee: ${p.committee.join(', ')}</em>` : `<br><em class="committee">Committee: ${p.committee}</em>`) : '';

  const container = document.createElement('div');
  // render optional notes (awards, honors, comments) for any entry
  let notesText = p.notes ? (Array.isArray(p.notes) ? p.notes.join(', ') : p.notes) : null;
  // remove round parentheses from notes if present (user requested no parentheses)
  // if (notesText) notesText = String(notesText).replace(/[()]/g, '');

  // render notes on their own line immediately after the venue/meta with bold styling and no label
  const notesHTML = notesText ? `<div class="notes" style="font-weight:700; margin-top:0">${notesText}</div>` : '';
  container.innerHTML = `<em>${title}</em><br>${meta}${notesHTML}${committeeHTML}`;

      // resources (paper/pdf, code, slides, video)
  const resources = document.createElement('div');
  // remove extra gap before buttons so they appear directly after the meta text
  resources.style.marginTop = '0';
      // Paper button: prefer url_paper, then explicit pdf, then arXiv pdf derived from url
      const paperUrl = p.url_paper || p.pdf || (p.url && p.url.includes('arxiv.org') && p.url.replace('/abs/','/pdf/')) || null;
      if (paperUrl) {
        const b = makeButton('paper', paperUrl);
        resources.appendChild(b);
      }
      if (p.code) resources.appendChild(makeButton('code', p.code));
      if (p.slides) resources.appendChild(makeButton('slides', p.slides));
      if (p.video) resources.appendChild(makeButton('video', p.video));

      // Abstract button: always show. If we have an inline abstract, toggle it; otherwise open the URL (if any).
      let pendingAbstract = null;
      let pendingBib = null;
      (function(){
        const aid = `abstract-${idx}`;
        const abtn = document.createElement('button');
        abtn.className = 'button';
        abtn.innerHTML = `<i class="fa fa-align-left"></i> Abstract`;
        if (p.abstract) {
          abtn.setAttribute('data-target', aid);
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
          // open URL (prefer arXiv abstract page)
          abtn.onclick = () => {
            try { window.open(p.url, '_blank', 'noopener'); } catch(e) { window.location.href = p.url; }
          };
          resources.appendChild(abtn);
        } else {
          abtn.disabled = true;
          resources.appendChild(abtn);
        }
      })();
      if (p.bibtex) {
        const bid = `bib-${idx}`;
        const bbtn = makeButton('bib');
        bbtn.setAttribute('data-target', bid);
        resources.appendChild(bbtn);
        const bdiv = document.createElement('div');
        bdiv.className = 'boxcitation';
        bdiv.id = bid;
        bdiv.style.display = 'none';
        bdiv.innerHTML = `<pre style="white-space:pre-wrap">${p.bibtex}</pre>`;
        pendingBib = bdiv;
      }

  li.appendChild(container);
      li.appendChild(resources);
      if (pendingAbstract) li.appendChild(pendingAbstract);
      if (pendingBib) li.appendChild(pendingBib);

      // append to the appropriate list if present; fallback to first available list
      const appendTo = (el) => { if (el) el.appendChild(li); else {
        // fallback: append to preprints if available, otherwise journal, otherwise document body
        if (pre) pre.appendChild(li);
        else if (journal) journal.appendChild(li);
        else document.body.appendChild(li);
      }};

      if (p.type === 'preprint') appendTo(pre);
      else if (p.type === 'journal') appendTo(journal);
      else if (p.type === 'cs_conference') appendTo(csconf || pre);
      else if (p.type === 'conference') appendTo(document.getElementById('conferences-list') || pre);
      else if (p.type === 'dissertation') appendTo(diss || pre);
      else if (p.type === 'lecture_notes') appendTo(lnotes || pre);
      else appendTo(pre);

  // debug logs when committee or notes are present
  if (p.committee) console.info('Rendered committee for:', p.title, p.committee);
  if (p.notes) console.info('Rendered notes for:', p.title, p.notes);
      
      // After rendering dissertations, remove any duplicate static 'Dissertations' blocks
      try {
        const headers = Array.from(document.querySelectorAll('h2'));
        headers.forEach(h => {
          if (h.textContent && h.textContent.trim().toLowerCase() === 'dissertations') {
            // if this header DOES NOT contain our generated list, and there's a following UL, remove it
            if (!h.querySelector('#dissertations-list')) {
              const next = h.nextElementSibling;
              if (next && next.tagName && next.tagName.toLowerCase() === 'p') {
                // remove the paragraph that wraps the old UL if present
                const ul = next.querySelector('ul');
                if (ul) next.remove();
              }
              // remove the header itself if it's a leftover static block placed after main
              if (!h.closest('main')) h.remove();
            }
          }
        });
      } catch (e) {
        // ignore cleanup errors
      }
    });
  } catch(e) {
    console.error('Failed to load publications.json', e);
  }
})();

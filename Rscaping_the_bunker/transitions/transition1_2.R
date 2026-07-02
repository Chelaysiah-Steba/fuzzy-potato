transition1_2_ui <- function() {
  fluidPage(
    useShinyjs(),
    
    tags$head(
      tags$style(HTML("
html, body {
margin: 0;
padding: 0;
width: 100%;
height: 100%;
background: #1c1c1c;
overflow: hidden;
font-family: 'Courier New', Courier, monospace;
color: #00FF00;
}

body {
background:
radial-gradient(circle at center, rgba(0,255,0,0.05) 0%, rgba(0,0,0,0) 55%),
linear-gradient(180deg, #1c1c1c 0%, #111 100%);
text-shadow: 0 0 6px rgba(0,255,0,0.65), 0 0 12px rgba(0,255,0,0.25);
}

.helix9-wrap {
position: fixed;
inset: 0;
display: flex;
align-items: center;
justify-content: center;
padding: 24px;
box-sizing: border-box;
}

.helix9-terminal {
width: min(980px, 96vw);
min-height: 620px;
border: 1px solid rgba(0,255,0,0.35);
background: rgba(6, 10, 6, 0.92);
box-shadow:
0 0 0 1px rgba(0,255,0,0.12) inset,
0 0 24px rgba(0,255,0,0.12),
0 0 60px rgba(0,255,0,0.07);
padding: 28px 28px 24px 28px;
box-sizing: border-box;
position: relative;
animation: terminalFlicker 8s infinite steps(1, end);
}

.helix9-title {
text-align: center;
font-size: clamp(30px, 4vw, 54px);
letter-spacing: 4px;
margin: 0 0 26px 0;
font-weight: 700;
animation: glowPulse 1.8s ease-in-out infinite;
}

.helix9-output {
height: 355px;
overflow: hidden;
white-space: pre-wrap;
word-break: break-word;
border: 1px solid rgba(0,255,0,0.22);
background: rgba(0,0,0,0.2);
padding: 18px 18px 16px 18px;
box-sizing: border-box;
font-size: 18px;
line-height: 1.45;
box-shadow: 0 0 18px rgba(0,255,0,0.08) inset;
}

.line {
min-height: 1.45em;
}

.cursor {
display: inline-block;
width: 10px;
animation: blink 1s step-end infinite;
}

.progress-wrap {
margin-top: 18px;
border: 1px solid rgba(0,255,0,0.25);
height: 24px;
background: rgba(0,0,0,0.45);
box-shadow: 0 0 14px rgba(0,255,0,0.06) inset;
overflow: hidden;
}

.progress-bar {
height: 100%;
width: 0%;
background: linear-gradient(90deg, rgba(0,255,0,0.55), rgba(0,255,0,0.95));
box-shadow: 0 0 16px rgba(0,255,0,0.5);
transition: width 280ms linear;
}

.continue-btn {
display: none;
margin: 22px auto 0 auto;
padding: 14px 28px;
border: 1px solid rgba(0,255,0,0.65);
background: rgba(0,0,0,0.72);
color: #00FF00;
font-family: 'Courier New', Courier, monospace;
font-size: 18px;
letter-spacing: 1px;
cursor: pointer;
text-transform: uppercase;
box-shadow: 0 0 18px rgba(0,255,0,0.25);
opacity: 0;
transform: translateY(8px);
}

.continue-btn.show {
display: block;
animation: fadeInButton 1.2s ease forwards;
}

@keyframes blink {
50% { opacity: 0; }
}

@keyframes glowPulse {
0%, 100% { text-shadow: 0 0 6px rgba(0,255,0,0.6), 0 0 14px rgba(0,255,0,0.22); }
50% { text-shadow: 0 0 10px rgba(0,255,0,0.95), 0 0 24px rgba(0,255,0,0.42); }
}

@keyframes terminalFlicker {
0%, 100% { opacity: 1; }
98% { opacity: 0.98; }
99% { opacity: 0.92; }
}

@keyframes fadeInButton {
0% { opacity: 0; transform: translateY(8px); }
100% { opacity: 1; transform: translateY(0); }
}
")),
      tags$script(HTML("
(function() {
function getEl(id) { return document.getElementById(id); }
function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

function appendLine(text, cls) {
const out = getEl('transition1_2_output');
const line = document.createElement('div');
line.className = 'line' + (cls ? ' ' + cls : '');
line.textContent = text;
out.appendChild(line);
out.scrollTop = out.scrollHeight;
}

function typeLine(text, delay, cls) {
return new Promise(async resolve => {
const out = getEl('transition1_2_output');
const line = document.createElement('div');
line.className = 'line' + (cls ? ' ' + cls : '');
out.appendChild(line);
out.scrollTop = out.scrollHeight;
let current = '';
for (let i = 0; i < text.length; i++) {
current += text[i];
line.textContent = current;
out.scrollTop = out.scrollHeight;
await sleep(delay);
}
resolve();
});
}

async function runSequence() {
const out = getEl('transition1_2_output');
const bar = getEl('transition1_2_bar');
const btn = getEl('transition1_2_button');
if (!out || !bar || !btn) return;

out.innerHTML = '';
btn.classList.remove('show');
btn.style.display = 'none';
btn.style.opacity = '0';
btn.style.transform = 'translateY(8px)';
bar.style.width = '0%';

await typeLine('AUTHENTICATION CODE ACCEPTED', 30);
await sleep(300);
await typeLine('> Verifying credentials...', 18);

const msgs = [
'> Security Module 3/3 activated.',
'> Restoring central database...',
'> Reconnecting laboratory network...',
'> Updating security protocols...'
];

const steps =;

for (let i = 0; i < msgs.length; i++) {
await sleep(260);
await typeLine(msgs[i], 16);
bar.style.width = steps[i] + '%';
}

await sleep(350);
bar.style.width = '100%';
await sleep(500);

appendLine('==========================');
appendLine('ACCESS GRANTED');
appendLine('==========================');
await sleep(700);

await typeLine('Security Database:', 18);
await typeLine('ONLINE', 18);
await sleep(160);
await typeLine('Laboratory Network:', 18);
await typeLine('ONLINE', 18);
await sleep(160);
await typeLine('Research Terminal:', 18);
await typeLine('AVAILABLE', 18);
await sleep(160);
await typeLine('Containment Status:', 18);
await typeLine('STABLE', 18);
await sleep(500);

await typeLine('De eerste beveiligingssystemen zijn succesvol hersteld.', 18);
await sleep(220);
await typeLine('Hierdoor is toegang verkregen tot de volgende onderzoeksmodule.', 18);
await sleep(220);
await typeLine('De resterende systemen zijn nog niet volledig operationeel.', 18);
await sleep(220);
await typeLine('Analyseer de laboratoriumgegevens om de volgende beveiligingsprotocollen te herstellen.', 18);
await sleep(500);

btn.style.display = 'block';
requestAnimationFrame(function() {
btn.classList.add('show');
});
}

document.addEventListener('shiny:connected', function() {
setTimeout(runSequence, 250);
});

window.transition1_2StartSequence = runSequence;

document.addEventListener('click', function(e) {
if (e.target && e.target.id === 'transition1_2_button') {
if (window.Shiny && Shiny.setInputValue) {
Shiny.setInputValue('transition1_2_continue', Math.random(), {priority: 'event'});
}
}
});
})();
"))
    ),
    
    div(
      class = "helix9-wrap",
      tags$div(
        id = "transition1_2_terminal",
        class = "helix9-terminal",
        tags$div(class = "helix9-title", "HELIX-9 CENTRAL SYSTEM"),
        tags$div(id = "transition1_2_output", class = "helix9-output"),
        tags$div(class = "progress-wrap", tags$div(id = "transition1_2_bar", class = "progress-bar")),
        actionButton("transition1_2_button", "CONTINUE", class = "continue-btn")
      )
    )
  ) }

transition_1_2_server <- function(input, output, session, current_page) {
  observeEvent(input$transition1_2_continue, {
    current_page("level2_intro")
  }, ignoreInit = TRUE)
}
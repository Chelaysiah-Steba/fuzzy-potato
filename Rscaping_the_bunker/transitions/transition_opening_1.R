transition_opening_1_ui <- function() {
  tags$div(
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

        .helix9-terminal.shake {
          animation: terminalFlicker 8s infinite steps(1, end), terminalShake 0.18s linear 0s 12;
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

        .override-btn {
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

        .override-btn.show {
          display: block;
          animation: fadeInButton 1.2s ease forwards;
        }

        .glitch {
          position: relative;
          color: #00ff00;
          animation: glitchText 0.12s linear 0s 12;
        }

        .system-failure {
          text-align: center;
          margin: 10px 0 14px 0;
          font-size: clamp(22px, 2.8vw, 38px);
          line-height: 1.25;
        }

        .big-failure {
          text-align: center;
          font-size: clamp(24px, 3vw, 42px);
          line-height: 1.2;
          margin: 8px 0;
        }

        .danger {
          color: #7CFF7C;
          font-weight: 700;
        }

        .red-flash {
          position: fixed;
          inset: 0;
          background: rgba(255, 0, 0, 0);
          pointer-events: none;
          z-index: 9999;
        }

        .red-flash.active {
          animation: redFlash 0.35s ease-out 1;
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

        @keyframes terminalShake {
          0% { transform: translate(0, 0); }
          25% { transform: translate(1px, -1px); }
          50% { transform: translate(-1px, 1px); }
          75% { transform: translate(1px, 1px); }
          100% { transform: translate(0, 0); }
        }

        @keyframes glitchText {
          0% { transform: translate(0); filter: none; }
          20% { transform: translate(-1px, 0); }
          40% { transform: translate(1px, -1px); }
          60% { transform: translate(-2px, 1px); filter: contrast(1.2); }
          80% { transform: translate(2px, 0); }
          100% { transform: translate(0); filter: none; }
        }

        @keyframes redFlash {
          0% { background: rgba(255,0,0,0); }
          20% { background: rgba(255,0,0,0.18); }
          100% { background: rgba(255,0,0,0); }
        }

        @keyframes fadeInButton {
          0% { opacity: 0; transform: translateY(8px); }
          100% { opacity: 1; transform: translateY(0); }
        }
      ")),
      tags$script(HTML("
        (function() {
          function ensureOverlay() {
            if (!document.getElementById('helix9-red-flash')) {
              const d = document.createElement('div');
              d.id = 'helix9-red-flash';
              d.className = 'red-flash';
              document.body.appendChild(d);
            }
          }

          function getEl(id) { return document.getElementById(id); }

          function appendLine(text, cls) {
            const out = getEl('helix9-output');
            const line = document.createElement('div');
            line.className = 'line' + (cls ? ' ' + cls : '');
            line.textContent = text;
            out.appendChild(line);
            out.scrollTop = out.scrollHeight;
          }

          function setLine(index, text, cls) {
            const out = getEl('helix9-output');
            const lines = out.querySelectorAll('.line');
            if (lines[index]) {
              lines[index].textContent = text;
              lines[index].className = 'line' + (cls ? ' ' + cls : '');
              out.scrollTop = out.scrollHeight;
            } else {
              appendLine(text, cls);
            }
          }

          function lastLineIndex() {
            const out = getEl('helix9-output');
            return out.querySelectorAll('.line').length - 1;
          }

          function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

          function typeLine(text, delay, cls) {
            return new Promise(async resolve => {
              const out = getEl('helix9-output');
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

          function randGarbage() {
            const pool = ['0x4A##@','##%%&','101001001','A9F11X','!!!@@##','//ERR//','<CORRUPT>','?*?*?*','B7::L9','XN-404'];
            return pool[Math.floor(Math.random() * pool.length)];
          }

          async function glitchSequence() {
            const terminal = getEl('helix9-terminal');
            const out = getEl('helix9-output');
            terminal.classList.add('shake');
            out.classList.add('glitch');
            const flash = getEl('helix9-red-flash');
            if (flash) {
              flash.classList.remove('active');
              void flash.offsetWidth;
              flash.classList.add('active');
            }
            if (window.Shiny && Shiny.setInputValue) {
              Shiny.setInputValue('helix9_glitch', Math.random(), {priority: 'event'});
            }
            await sleep(250);
            appendLine('> SIGNAL LOST');
            await sleep(220);
            appendLine('> NODE TIMEOUT');
            await sleep(220);
            appendLine('> CONNECTION INTERRUPTED');
            await sleep(220);
            for (let i = 0; i < 8; i++) {
              appendLine(randGarbage(), 'glitch');
              await sleep(120);
            }
            await sleep(600);
            terminal.classList.remove('shake');
            out.classList.remove('glitch');
          }

          async function runSequence() {
            ensureOverlay();
            const out = getEl('helix9-output');
            const bar = getEl('helix9-bar');
            const btn = getEl('helix9-button');
            const terminal = getEl('helix9-terminal');
            if (!out || !bar || !btn || !terminal) return;

            out.innerHTML = '';
            btn.classList.remove('show');
            btn.style.display = 'none';
            btn.style.opacity = '0';
            btn.style.transform = 'translateY(8px)';
            bar.style.width = '0%';

            await typeLine('HELIX-9 BIOS INITIALIZED', 35);
            await sleep(350);
            await typeLine('> Connecting to Central Security Network...', 18);

            const msgs = [
              '> Checking reactor status...',
              '> Restoring network nodes...',
              '> Connecting to Security AI...',
              '> Verifying containment...',
              '> Accessing Security Database...',
              '> Loading Emergency Protocols...',
              '> Synchronizing Containment Systems...'
            ];

            let p = 8;
            for (let i = 0; i < msgs.length; i++) {
              await sleep(280);
              await typeLine(msgs[i], 16);
              p += (70 / msgs.length);
              bar.style.width = Math.min(78, p) + '%';
            }

            bar.style.width = '78%';
            await sleep(550);
            await glitchSequence();

            await sleep(180);
            await typeLine('RETRY 1/3', 28);
            await sleep(260);
            appendLine('FAILED');
            await sleep(650);
            await typeLine('RETRY 2/3', 28);
            await sleep(260);
            appendLine('FAILED');
            await sleep(650);
            await typeLine('RETRY 3/3', 28);
            await sleep(260);
            appendLine('FAILED');
            await sleep(700);

            appendLine('==============================');
            appendLine('SYSTEM FAILURE');
            appendLine('AUTOMATED RECOVERY FAILED');
            appendLine('==============================');
            await sleep(1100);

            await typeLine('Primary control network unreachable.', 18);
            await sleep(240);
            await typeLine('Security protocols remain offline.', 18);
            await sleep(240);
            await typeLine('Containment Status:', 18);
            await typeLine('CRITICAL', 18, 'danger');
            await sleep(260);
            appendLine('WARNING', 'danger');
            await sleep(260);
            await typeLine('Automatic restoration unavailable.', 18);
            await sleep(240);
            await typeLine('Manual intervention required.', 18);
            await sleep(500);

            btn.style.display = 'block';
            requestAnimationFrame(function() {
              btn.classList.add('show');
            });
          }

          document.addEventListener('shiny:connected', function() {
            setTimeout(runSequence, 250);
          });

          window.helix9StartSequence = runSequence;

          if (window.Shiny && Shiny.addCustomMessageHandler) {
            Shiny.addCustomMessageHandler('redFlash', function(message) {
              ensureOverlay();
              const flash = getEl('helix9-red-flash');
              if (!flash) return;
              flash.classList.remove('active');
              void flash.offsetWidth;
              flash.classList.add('active');
            });
          } else {
            document.addEventListener('shiny:connected', function() {
              if (window.Shiny && Shiny.addCustomMessageHandler) {
                Shiny.addCustomMessageHandler('redFlash', function(message) {
                  ensureOverlay();
                  const flash = getEl('helix9-red-flash');
                  if (!flash) return;
                  flash.classList.remove('active');
                  void flash.offsetWidth;
                  flash.classList.add('active');
                });
              }
            });
          }

          document.addEventListener('click', function(e) {
            if (e.target && e.target.id === 'helix9-button') {
              if (window.Shiny && Shiny.setInputValue) {
                Shiny.setInputValue('helix9_manual_override', Math.random(), {priority: 'event'});
              }
            }
          });
        })();
      "))
    ),
    tags$div(
      class = "helix9-wrap",
      tags$div(
        id = "helix9-terminal",
        class = "helix9-terminal",
        tags$div(class = "helix9-title", "HELIX-9 CENTRAL SYSTEM"),
        tags$div(id = "helix9-output", class = "helix9-output"),
        tags$div(class = "progress-wrap", tags$div(id = "helix9-bar", class = "progress-bar")),
        actionButton("helix9_button", "INITIALIZE MANUAL OVERRIDE", class = "override-btn")
      )
    )
  )
}

transition_opening_1_server <- function(input, output, session, current_page) {
  observeEvent(input$helix9_button, {
    current_page("level1_intro")
  }, ignoreInit = TRUE)
  
  observeEvent(input$helix9_manual_override, {
    current_page("level1_intro")
  }, ignoreInit = TRUE)
  
  observeEvent(input$helix9_glitch, {
    session$sendCustomMessage("redFlash", TRUE)
  }, ignoreInit = TRUE)
}
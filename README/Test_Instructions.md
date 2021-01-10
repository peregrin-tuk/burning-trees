Burning Trees

# Testing Instructions 

### Notes

- Die maximale Dauer des Spiels kann in *BurningTrees.pde* Zeile 6 zu Testzwecken verändert werden.
  Die tatsächliche Dauer ist abhängig von der Spielerposition, bei einer maximalen Dauer von 12 min ist die minimale 30 Sekunden (min = max/24).
  Je näher die Spieler zur Wand sind, desto kürzer ist die Dauer der Installation.
- Jedem Spieler ist eine Tonspur zugeordnet, der wiederum ein Baum an der Wand zugeordnet ist. Je weiter der Spieler von der Wandprojektion entfernt ist, desto ruhiger und natürlicher soll seine Tonspur klingen. Je näher man der Wand kommt, desto aufgeregter und hektischer werden Tonspur und Visualiserung.
- [ ! ] Zum Testen mit nur einer Testversion ist ein One-Player-Mode implementiert. Dieser kann mit **"o"** aktiviert werden. Mit den Ziffern **0-5** können die Tonspuren gewechselt werden. Um zu sehen, welche Player ID gerade aktiv ist, können mit **"t"** Test-Outputs eingeblendet werden.



### Wichtige Tests

- [ ] Richtige WallHeight (Baumstämme beginnen genau an Kante zw. Floor und Wall).
- [ ] Mit wie vielen FPS läuft die Applikation? (können mit **"f"** eingeblendet werden).
- [ ] Wenn ein Spieler den Floor betritt, ist Audio zu hören.
- [ ] Das Audio verändert sich wenn der Spieler näher zur Wand geht.
- [ ] Die Visualisierung (Farbe + Animation) ändert sich analog zum Audio
- [ ] Stehen alle Spieler direkt an der Wandprojektion soll nach max. 30 Sekunden die Endcard erscheinen.



### Weitere Tests

- [ ] Bewegt sich der Spieler nach links oder rechts, sollte die dazugehörende Audiospur entsprechend pannen.
- [ ] Subjektiver Eindruck: Passen Audio und Visualisierung im Deep Space zusammen? / Lässt sich erkennen welcher Baum mit welchem Spieler verbunden ist?
- [ ] Mix Musik: Bass nicht zu laut / jedes Instrument hörbar und halbwegs präsent.





### Troubleshooting

**Kein Ton aus Max**:
Die Soundkarte auf die der Ton ausgegeben wird lässt sich unter */Options/Audio Status... > Output Device* umstellen
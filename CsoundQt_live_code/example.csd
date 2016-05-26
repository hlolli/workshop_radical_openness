<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1.0

#include "live_loop.udo"


instr 1
;Key control                                            root-midi-note scale-type
live_loop "key_change", "0 1 2 3", "example_tonality 0.1 [48 50 51 47] [0 0 1 2]", 4, 15
;Instruments                                                             scale arr-indx
live_loop "sopr", "0 1 2 3 3.5",  "synth_soprano [2.2 2.2 1.9 1.7 4] -32 [2 1 0 5 4 3 2]", 8, 120
live_loop "alto", "0 0.5 1.5 2.5 3.5",  "synth_alto [0.5 0.3 0.3 0.3] -27 [4 2 4 2 0 7]", 4, 120
;                                                               chord-note-indx
live_loop "basso", "0 1 2 3",  "synth_alberti [0.5 0.4 0.3] -25 [0 3 2 1 5 4]", 4, 240
endin

instr example_tonality
if p5 == 0 then
giChord[] fillarray 0, 4, 7, 12, 16, 19 ;Major Chord
giScale[] fillarray 0, 2, 4, 5, 7, 9, 11, 12 ;Major Scale
elseif p5 == 1 then
giChord[] fillarray 0, 3, 7, 12, 15, 19 ;Minor
giScale[] fillarray 0, 2, 3, 5, 7, 8, 11, 12 ;Harmonic Minor
elseif p5 == 2 then
giChord[] fillarray 0, 4, 7, 10, 12, 16 ;Dominant
giScale[] fillarray 0, 2, 4, 7, 9, 10, 12 ;Mixolydian
endif
giChordLen lenarray giChord
giScaleLen lenarray giScale
giGlobalRoot = p4
endin

instr synth_soprano
iamp = ampdb(p4)
ifreq = cpsmidinn(giGlobalRoot+giScale[p5 % giScaleLen]+12)
asig vco2 iamp, ifreq
aenv adsr 0.1, 0.3, 0.1, 0.1
afilt moogvcf2 asig, ifreq*2.001, 0.3
outs afilt*aenv, afilt*aenv
endin

instr synth_alto
iamp = ampdb(p4)
ifreq = cpsmidinn(giGlobalRoot+giScale[p5 % giScaleLen])
asig vco2 iamp, ifreq*1.01
asig2 vco2 iamp, ifreq*0.98
aenv adsr 0.3, 0.1, 0.8, 0.3
afilt moogvcf2 (asig+asig2)/2, ifreq*1.7, 0.9
outs afilt*aenv, afilt*aenv
endin

instr synth_alberti
iamp = ampdb(p4)
ifreq = cpsmidinn(giGlobalRoot+giChord[p5 % giChordLen]-12)
asig vco2 iamp, ifreq
aenv expon 1, p3, 0.1
afilt moogvcf2 asig, 310, 0.9
outs afilt*aenv, afilt*aenv
endin

</CsInstruments>
<CsScore>
{10000 x
i 1 $x 1
}
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>

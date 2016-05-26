# workshop_radical_openness
Workshop 27th of May

#Basic concepts
##Time
In all music, time is the dimension the artist manipulates. With numbers and algorithms we need a way to express events in time. Standard western music notation can be seen as a language is same manner as a programming language is to a programmer (only that the score would be a domain specific language, just like panaeolus). Many (sucessful) attempts have been made to extend the standard music notation to include algorithmic characters, to be translated and understood by the performer. In most cases, this is avoided and a classicaly trained performer assumes in most cases a musical language that can be read and performed directly without further translation. To make my case short, as computer musicians we need to tell the computer what to do and when to do. For real-time computer music performer working with code, we must rely on algorithms and understand the functions we are working with to be able to become expressive or willingly stochastic.

##Arrays
Array, or depending on the programming language you are used to (ex. vector, lists, linked lists, persistent lists etc) is an indexed data structure that can be traversed randomly or linearly with index. Even though most live-coding performances rely heavily on arrays, there are many exceptions, especially when pattern and sound-design is not decoupled. In this sense so called "supercollider (twitter) tweets" show very interesting patterns and aucustics using only 140 letters of code. But let's get back to arrays:

`Supercollider code from Frederik Olofsson http://www.fredrikolofsson.com/f0blog/?q=node/637`
```Supercollider
MySequencerTrack {
        var <steps;
        var <>array;
        *new {|steps= 16|
                ^super.newCopyArgs(steps).init;
        }
        init {
                array= Array.fill(4, {Array.fill(steps, 0)});  //4 here because of the four params: amp, freq, mod, pan
        }
        //array get/set
        amps {^array[0]}
        amps_ {|arr| array[0]= arr}
        freqs {^array[1]}
        freqs_ {|arr| array[1]= arr}
        mods {^array[2]}
        mods_ {|arr| array[2]= arr}
        pans {^array[3]}
        pans_ {|arr| array[3]= arr}
        //single value get/set
        amp {|index| ^array[0][index]}
        amp_ {|index, val| array[0].put(index, val)}
        freq {|index| ^array[1][index]}
        freq_ {|index, val| array[1].put(index, val)}
        mod {|index| ^array[2][index]}
        mod_ {|index, val| array[2].put(index, val)}
        pan {|index| ^array[3][index]}
        pan_ {|index, val| array[3].put(index, val)}
}
```
In this supercollider example we see how 16 step sequencer can be created with 4 arrays representing 4 parameters each containing 16 "slots" (starting at 0 and ending at 15). In other words a 4 x 16 dimension array is enough to create a traditional step-sequencer (the word **step** in a step-sequencer would here be the value of the index).

Not counting lazy-sequences (a concept outside the scope of this workshop), each array has an end. And if we ask a program for a value at a specific index that is greater than the size of the array, then we end up either crashing the program or alerted with a mean warning. To prevent this, we need to limit the index so that it never reaches a greater value than of the array size, for the algorithmic music performer, the tool for the job is **modulo**.

##Modulo
The name modulo can be seen in the wild under different synonyms: **mod**, **%** or **rem**. Let's look at a pattern created with Tidal (a popular live-coding library developed by alex mclean):
```Haskell
d1 $ sound "bd sn hh cp mt arpy drum"
```
This seven element pattern will loop in cycles. To achieve this, the number of elements within the qutation marks are counted, in this case 7. A counter is initialized at the number 0. Then for every note event the counter is incremented which then in return is divided with the value of the modulo, which then is used as index lookup value for the next musical event. Ending with a pattern like so:
```
sound:   bd sn hh cp mt arpy drum  bd sn  hh cp  mt arpy drum ...
index:   0  1  2   3 4   5    6    0   1  2   3   4   5    6 ...
counter: 0  1  2   3 4   5    6    7   8  9  10  11   12  13 ...
```

##The functions of a melody
A melody in a traditional sense, is not only a dimension of time, but also a dimension of pitch (if we simplify things extreamly). This adds a much complexity, because now we have more than one array to think about, and in case we want to be exact, they need to match. Take this example from Chris Ford's library Leipzig (leipzig is a Clojure library based on Overtone (which is based on Supercollider)).
```Clojure
(def melody "A simple melody built from durations and pitches."
              ; Row, row, row  your boat,
  (->> (phrase [3/3  3/3  2/3  1/3  3/3]
               [  0    0    0    1    2])
    (then
              ; Gent-ly  down the  stream,
       (phrase [2/3  1/3  2/3  1/3  6/3]
               [  2    1    2    3    4]))
    (then
              ; Merrily, merrily, merrily, merrily,
       (phrase (repeat 12 1/3)
               (mapcat (partial repeat 3) [7 4 2 0])))
    (then
             ; Life  is   but  a    dream!
       (phrase [2/3  1/3  2/3  1/3  6/3]
               [  4    3    2    1    0]))
    (all :part :leader)))
  ```
  This short song consists here of three phrases played one after the other. Each phrase consisting of two equal length vectors (a clojure way of naming an array), first one representing the duration of the note event and the second one representing a position within a given scale (so transposing these patterns from major to minor becomes trivial as demonstrated here: https://github.com/ctford/leipzig). Were these vector pairs not of equal length, a mismatch would couse this pretty little song to sound something different.
  
  In a live coding, performing pre-composed music is almost impossible, and can be argued that goes against the idea of live coding (depending who you ask). So when designing an environment for live-algorithmic music, something has got to give away. Panaeolus was in this sense to be more rythmically oriented than melodically, as can be seen later, many ways exist to apply rythmical pattern to a given melodic pattern (or simply an array of frequencies within the sampling rate limit).

#Lisp(Clojure)
####Why lisp?
Lisp is a family of programming langages dating back to the 1960's. Musicians have for long time used lisp because of its functional high-level programming. It would be my argument that Haskell is the alpha and omega of functional programming, as such, a very diffucult programming langage to tame. On the other hand, lisp is weird, but lisp is relatively easy. For musicians that want to focus on creating algorithms, patterns and music; language that is flexible, functional and extensible should be embraced. Supercollider/sclang is in comparison (to PD, Max and Csound) a rather functionalish programming language, which may explain it's popularity in the live-coding scene. To name a few of many programs using lisp:
- Common Lisp Music https://ccrma.stanford.edu/software/clm/
- Fluxus http://www.pawfal.org/fluxus/
- Overtone http://overtone.github.io/
- Alda http://alda.io/
- Extempore http://extempore.moso.com.au/
- CALMUS http://www.calmus.is/
- Opusmodus http://opusmodus.com/
These formentioned programs rely on various types of lisp, but for the remainder the focus will be set on Clojure.

####Very basics (Clojure)
_Data structures_
```Clojure
[1 2 3]            ; A vector (can access items by index).
[1 :two "three"]   ; Put anything into them you like.
{:a 1 :b 2}        ; A hashmap (or just "map", for short).
#{:a :b :c}        ; A set (unordered, and contains no duplicates).
'(1 2 3)           ; A list (linked-list)
```
_Polish notation_
In lisp everything is stored in parenthesis and the _verb_ (or to simplify the function) is always the first thing in a list.
For example a vector `[1 2 3]` is simply a syntactic sugar for `(vector 1 2 3)`. For multiplication one would have to write it like this `(* 1 2 3 4) => 24` and summing up numbers would be `(+ 1 2 3 4) => 10`. This mathematical notation is sometimes called a polish notation and dominaties all lisps. Programmers new to lisp usually get used to this very quickly.
Lets take another example: `1 - (10 - 1) + (3 * 2)` would be written in clojure as: `(+ (- 1 (- 10 1)) (* 3 2))`.

_Functions_
Mathematical operators in Clojure are also functions, they always take the first position as with all function calls. These two functions are compleatly the same: 
```Clojure
((fn [a b] (+ a b)) 2 3) => 5
```
and
```Clojure
(defn sum-two-numbers [a b]
    (+ a b))

(sum-two-numbers 2 3) => 5
```
With the only difference that the first one is not reuseable since it has no symbol defined to is, and the second one can be used many times.
####Panaeolus basics
For more information about the inner workings of Panaeolus I leave this link as an optional reading material: https://zenodo.org/record/50366?ln=en#.V0cKK0JRqV5
Panaeolus is based in predefined instruments that can by played simply by calling its name. Evaluate
`(sweet)` and a sound should be played using only default parameter values. It is possible to change the parameters by a keyword name (always starting with `:`) and the parameter name. So if we want to play the instrument sweet at 100Hz for 5 seconds we would write `(sweet :dur 5 :freq 100)`. While it is possible to have fun with single note events, the real fun begins when wrapping the instruments in the dollar sign macros. The dollar sign macros start with the number 1 ending with number 100, each number means one track, so it is possible to start 100 tracks (but most likely the cpu is going to complain at some point). So if we want to have the instrument sweet play the frequencies of: 100 200 300 400, with 1 second in between indefinitely, we would write `($1 (sweet :dur 0.5 :for [1 1 1 1] :freq [100 200 300 400]))` then here you have it.
In panaeolus you have various different ways of indicating a rythmical pattern, they are `:for`, `:on`, and `:pat`. `for` and `on` are almost the same, for indicates how long an event should take and on indicates when the event should takes followed one by another. So these two patterns sound the same: `:for [1 1 1 0.5 0.5]` and `:on [0 1 2 3 3.5]`. While `:on` and `:for` take either number or a vector of numbers, `:pat` (short for pattern) takes only a string. The same pattern (not respecting note value) with :pat would be `:pat "drum x x x x:4"`. 

[![Clojars Project](https://img.shields.io/clojars/v/panaeolus.svg)](https://clojars.org/panaeolus)

#Panaeolus
####Installation Mac
- 1. Install Csound https://github.com/csound/csound/releases/download/6.07.0/csound6.07-OSX-universal.dmg
- 2. Install Emacs https://emacsformacosx.com/emacs-builds/Emacs-24.5-1-universal.dmg
- 3. Install JavaJDK (if you haven't done so already) http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html (choose jdk-8u92-macosx-x64.dmg)
- 4. Install leiningen `$ brew install leiningen` or follow these instructions: http://leiningen.org/
- 5. In case we sound design, install CsoundQt, https://github.com/CsoundQt/CsoundQt/releases/download/0.9.2.1/CsoundQt-d-py-cs6-0.9.2.1-.dmg
- 6. Remove ~/.emacs.d folder and replace it with the folder inside this zip file, with same name (~/.emacs.d) https://github.com/hlolli/workshop_radical_openness/raw/master/emacs.d.zip
- 7. Install a good programming font: https://www.fontsquirrel.com/fonts/fira-mono (optional)
- 8. Do in terminal `lein new workshop-linz` .... (more info later)...

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

####1. Installation

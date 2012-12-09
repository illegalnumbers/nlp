1 - How to Compile and Run My Code:

    Ruby is pretty simple, all you have to do to run my code as
    specified by the problem assignment is type in 'ruby rtn.rb "dictionary_path" "rtn_specs_path" "test_file_path"'.

    If you want to run the tests that I have made myself (at the time
    of this submission there are about 30 of them, some in poor shape
    at the moment) just use rspec (Ruby's internal testing framework)
    by doing "rspec spec" (which runs rspec over the entire 'spec' 
    directory). This should work on the CADE machines, but I haven't
    tested to see if they include rspec yet or not so if it blows
    up, I swear they worked on my machine.

2 - Machine I tested on.

    I will be sshing into lab1-12.eng.utah.edu and testing my code
    from there before submitting.

3 - Known Bugs
    
    I know there is a problem with multiple parse routes right now.
    I am trying to resolve the issue but it's not looking like it
    will be resolved before the deadline, as such I am submitting my
    file as is now. It does do semi-shallow parses (ie. it will parse
    the sentence "john walks ." correctly) but the more complex, the
    more bugs show up and I am pretty sure that they are all related
    to the same thing (I am not handling backup states when the path's
    are chosen for an initial parse correctly). Hopefully I will be
    able to resolve this bug by tomorrow and resubmit for 90%...
    
    Other than that though I'm pretty stoaked on this project, it was
    really fun (although the last 10ish hours were super frustrating
    dealing with this bug). I was glad that I was allowed to use Ruby
    for it and I love a lot of things about this new language.

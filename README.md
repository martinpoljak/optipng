Optipng
=======

**Optipng** provides Ruby interface to the [`optipng`][1] tool. 
Some examples follow: (for details, see module documentation)

    require "optipng"
    
    Optipng.available?        # will return true (or false)
    
    Optipng.optimize(["foo.png", "empty.png", "nonexist.png"], { :level => 5 })
    
    # will run 'optipng -o 5 foo.png bar.png empty.png'
    # and then will return for example: 
    #   '#<struct Optipng::Result succeed={"foo.png => -22.1}}, errors=[["empty.png", "Unrecognized image file format"], ["nonexist.png", "Can't open the input file"]]>
    
### Call Result

Result contains members `:success` and `:errors`. Sucess member contains 
hash of successfully optimized files with ratio as value. Zero or 
positive percent ratio means the same as file has been skipped so 
already optimized. It's negative number against the number reported by 
`optipng` so it means new size against the old size.

Errors contains array with pairs where first member of the pair is 
filename and second the message. First one can be null if message isn't
strictly associated with concrete file. (But fortunately usually it is.) 

Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b 20101220-my-change`).
3. Commit your changes (`git commit -am "Added something"`).
4. Push to the branch (`git push origin 20101220-my-change`).
5. Create an [Issue][2] with a link to your branch.
6. Enjoy a refreshing Diet Coke and wait.

Copyright
---------

Copyright &copy; 2011 [Martin Kozák][3]. See `LICENSE.txt` for
further details.

[1]: http://optipng.sourceforge.net/
[2]: http://github.com/martinkozak/qrpc/issues
[3]: http://www.martinkozak.net/

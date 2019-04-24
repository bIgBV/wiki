
# Some notes on `sed`


Sed is freaking awesome. It takes in iput and performs substitutions, it works with regexes, but has some gotchas

Example regex to match on links in markdown.

```bash
sed -E 's/\]\(([-a-zA-Z0-9_\/]+)\)/](\1\.html)/'
```

This particular regex is matching on strings which look like the following:

```md
[13-September-2018](CS401/13-September-2018)
```

And transform them to

```md
[13-September-2018](CS401/13-September-2018.html)
```

A few notes:

* Since `[` are used for lists, they have to be escaped
* The `-E` here means extended mode and uses extended regular expressions, [see the GNU sed manual][1]. This changes the way the `+, ?` and other modifiers work.
* In Extended mode, groups are specified with just `()` so in order to match them, you have to escape them
* Matching groups can be used via `\1, \2..., \9`
* If you want to match on `-` in a list, then it has to be in the start or at the end of the list.

For more information see the [sed manual][2]


[1]: https://www.gnu.org/software/sed/manual/html_node/BRE-vs-ERE.html
[2]: https://www.gnu.org/software/sed/manual/html_node/BRE-syntax.html#BRE-syntax

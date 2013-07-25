# Git Print
## Print your GitHub issues to a Dymo LabelWriter 450 Turbo Printer or equivalent

![sample label](http://imgur.com/u4WgNSB.jpg)

1. Acquire a DYMO LabelWriter 450 Turbo (Maybe on [Amazon](http://www.amazon.com/gp/product/B0027JIIKQ/ref=as_li_tf_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0027JIIKQ&linkCode=as2&tag=gitpri-20)?)

2. Install the [drivers & software](http://global.dymo.com/ieIE/Software/LabelWriter_450.html) and connect your printer

3. Ensure you have [Ruby](https://rvm.io/rvm/install) installed 

4. Set environmental variables for your `GITHUB_USERNAME` and `GITHUB_PASSWORD`

```
cat << EOF >> ~/.bash_profile
export GITHUB_USERNAME='yourgithubemail@youremailhost.com'
export GITHUB_PASSWORD='yourgithubpassword'
EOF

source ~/.bash_profile
```

5. Modify `git_print.yml` with a repo, user, filter, and assignee you'd like to print issue changes for.

6. Migrate the database:

    `rake db:migrate`

7. Run the script, `ruby git_print.rb`, to start getting labels printed every time an issue with that assignee is modified! The script must be running for this to work.


## Contributing

Forks and contributions are welcome! Just send me a PR and I'll consider including it.

## Credits

Written by [@zachfeldman](http://zfeldman.com/) for the amusement of [@sanjayginde](https://twitter.com/sanjayginde) and the whole [@contently](https://contently.com/) product team.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/840a31089b7c9c72b0085b34f965f2ad "githalytics.com")](http://githalytics.com/zachfeldman/git_print)

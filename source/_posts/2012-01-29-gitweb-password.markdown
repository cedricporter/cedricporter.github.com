---
comments: true
date: 2012-01-29 16:35:19
layout: post
slug: gitweb-password
title: 给Gitweb加上访问密码，保护我们的私有项目
wordpress_id: 358
categories:
- IT
tags:
- Git
- Gitweb
---

Gitweb是Git提供的一个基于web的版本查看工具，可以在网页浏览我们的版本库，挺像Google Code上面的网页浏览版本库。我们可以使用cgi方式，让gitweb运行在apache中，如果在nginx上，我们还需要一个包装才可以运行cgi。

使用Gitweb很方便，但是如果是一些私有的项目，谁都可以访问想必大家都不能接受吧。

所以我们可以通过apache或者nginx给虚拟主机增加一个密码。效果如：[http://git.everet.org/](http://git.everet.org/)

我们首先用htpasswd生成密码：


> htpasswd -cb 文件名 帐号 密码

htpasswd -b 其他帐号 密码


-c代表创建一个新的，-b代表批处理。
<!-- more -->

我们可以在这里[htpasswd ](http://www.everet.org/wp-content/uploads/2012/01/htpasswd.rar)下载htpasswd.py，然后添加可执行权限，改名为htpasswd放到/usr/local/bin下，就可以在任意地方调用了。


> $ chmod +x htpasswd.py

$ cp htpasswd.py /usr/local/bin/htpasswd


然后，我们可以


> root@everet:~# htpasswd -cb gitweb username_et password

root@everet:~# cat gitweb

username_et:kPj.q84Ax1rrc


然后就在当前目录生成了一个gitweb的文件，里面就有帐号和密码，我们将其复制到某个地方，例如/etc/nginx/下。

我们修改我们的配置


> # gitweb

server {

listen   80; ## listen for ipv4

server_name  git.everet.org ;

access_log  off;

auth_basic "EverET.org Gitweb Server";

auth_basic_user_file /etc/nginx/gitweb;

root   /var/www/gitweb;

index   gitweb.cgi ;

location ~ \.(cgi|pl).*$ {

gzip off;

fastcgi_pass unix:/var/run/cgiwrap-fcgi/cgiwrap-fcgi.sock;

fastcgi_index index.cgi;

fastcgi_param SCRIPT_FILENAME /var/www/gitweb/gitweb.cgi;

fastcgi_param QUERY_STRING     $query_string;

fastcgi_param REQUEST_METHOD   $request_method;

fastcgi_param CONTENT_TYPE     $content_type;

fastcgi_param CONTENT_LENGTH   $content_length;

fastcgi_param GATEWAY_INTERFACE  CGI/1.1;

fastcgi_param SERVER_SOFTWARE    nginx;

fastcgi_param SCRIPT_NAME        $fastcgi_script_name;

fastcgi_param REQUEST_URI        $request_uri;

fastcgi_param DOCUMENT_URI       $document_uri;

fastcgi_param DOCUMENT_ROOT      /var/www/gitweb;

fastcgi_param SERVER_PROTOCOL    $server_protocol;

fastcgi_param REMOTE_ADDR        $remote_addr;

fastcgi_param REMOTE_PORT        $remote_port;

fastcgi_param SERVER_ADDR        $server_addr;

fastcgi_param SERVER_PORT        $server_port;

fastcgi_param SERVER_NAME        $server_name;

}

}


下面附上大牛写的htpasswd。点击这里下载 [htpasswd ](http://www.everet.org/wp-content/uploads/2012/01/htpasswd.rar)


{% codeblock python lang:python %}

#!/usr/bin/python
"""Replacement for htpasswd"""
# Original author: Eli Carter

import os
import sys
import random
from optparse import OptionParser

# We need a crypt module, but Windows doesn't have one by default.  Try to find
# one, and tell the user if we can't.
try:
    import crypt
except ImportError:
    try:
        import fcrypt as crypt
    except ImportError:
        sys.stderr.write("Cannot find a crypt module.  "
                         "Possibly http://carey.geek.nz/code/python-fcrypt/\n")
        sys.exit(1)

def salt():
    """Returns a string of 2 randome letters"""
    letters = 'abcdefghijklmnopqrstuvwxyz' \
              'ABCDEFGHIJKLMNOPQRSTUVWXYZ' \
              '0123456789/.'
    return random.choice(letters) + random.choice(letters)

class HtpasswdFile:
    """A class for manipulating htpasswd files."""

    def __init__(self, filename, create=False):
        self.entries = []
        self.filename = filename
        if not create:
            if os.path.exists(self.filename):
                self.load()
            else:
                raise Exception("%s does not exist" % self.filename)

    def load(self):
        """Read the htpasswd file into memory."""
        lines = open(self.filename, 'r').readlines()
        self.entries = []
        for line in lines:
            username, pwhash = line.split(':')
            entry = [username, pwhash.rstrip()]
            self.entries.append(entry)

    def save(self):
        """Write the htpasswd file to disk"""
        open(self.filename, 'w').writelines(["%s:%s\n" % (entry[0], entry[1])
                                             for entry in self.entries])

    def update(self, username, password):
        """Replace the entry for the given user, or add it if new."""
        pwhash = crypt.crypt(password, salt())
        matching_entries = [entry for entry in self.entries
                            if entry[0] == username]
        if matching_entries:
            matching_entries[0][1] = pwhash
        else:
            self.entries.append([username, pwhash])

    def delete(self, username):
        """Remove the entry for the given user."""
        self.entries = [entry for entry in self.entries
                        if entry[0] != username]

def main():
    """%prog [-c] -b filename username password
    Create or update an htpasswd file"""
    # For now, we only care about the use cases that affect tests/functional.py
    parser = OptionParser(usage=main.__doc__)
    parser.add_option('-b', action='store_true', dest='batch', default=False,
        help='Batch mode; password is passed on the command line IN THE CLEAR.'
        )
    parser.add_option('-c', action='store_true', dest='create', default=False,
        help='Create a new htpasswd file, overwriting any existing file.')
    parser.add_option('-D', action='store_true', dest='delete_user',
        default=False, help='Remove the given user from the password file.')

    options, args = parser.parse_args()

    def syntax_error(msg):
        """Utility function for displaying fatal error messages with usage
        help.
        """
        sys.stderr.write("Syntax error: " + msg)
        sys.stderr.write(parser.get_usage())
        sys.exit(1)

    if not options.batch:
        syntax_error("Only batch mode is supported\n")

    # Non-option arguments
    if len(args) < 2:
        syntax_error("Insufficient number of arguments.\n")
    filename, username = args[:2]
    if options.delete_user:
        if len(args) != 2:
            syntax_error("Incorrect number of arguments.\n")
        password = None
    else:
        if len(args) != 3:
            syntax_error("Incorrect number of arguments.\n")
        password = args[2]

    passwdfile = HtpasswdFile(filename, create=options.create)

    if options.delete_user:
        passwdfile.delete(username)
    else:
        passwdfile.update(username, password)

    passwdfile.save()

if __name__ == '__main__':
    main()


{% endcodeblock %}


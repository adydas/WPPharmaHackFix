#!/usr/bin/ruby -w
require "rubygems"
require "dbd/Mysql"
require "dbi"

begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:AMP:localhost","root", "")

     # get server version string and display it
     sth = dbh.execute ("select post_content, ID FROM wp_posts where post_content like '%display: none%'")
     while row = sth.fetch do
      #puts "Server version: " + row[0]
      new_str = row[0].gsub(/<(\s*)div(.*)display:(\s*)none(.*)<\/div>/, '')
      #new_str = new_str.gsub(/<(\s*)a(.*)>(.*)viagra(.*)<\/a>/,'')
      puts "Filtered string " + new_str
      
      uth = dbh.prepare ("update wp_posts set post_content = ? where ID = ?")
      uth.execute(new_str, row[1])
      uth.finish
   end
     dbh.commit   
     sth.finish
rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
     dbh.rollback
ensure
     # disconnect from server
     dbh.disconnect if dbh
end
# frozen_string_literal: true

require 'rubygems'
require 'rest-client'
require 'json'
require 'net/http'


file = File.open("./log/build_results.txt").each do |line|
  puts line
end
build_id = ARGV[0]
limit = 100
offset = 0
File.write('output.html',"<!DOCTYPE html><html><head><style>table {  font-family: arial, sans-serif;  border-collapse: collapse;  width: 100%;}td, th {  border: 1px solid #dddddd;  text-align: left;  padding: 8px;}</style></head><body><table>")
File.write('output.html', "<tr><th>Build Name</th><th>Project Name</th><th>Session Name</th><th>Browser Name</th><th>Browser Version</th><th>OS Name</th><th>OS Version</th><th>Device</th><th>Status</tr>", mode: 'a')
loop do
  base_url = "https://mayankmaurya4:JzJJjes3cyzHaynTqJpe@api.browserstack.com/automate/builds/9f103fe06027269a439c14711d544b9fa5b3f157/sessions.json?limit=#{limit}&offset=#{offset}"
  results = RestClient.get(base_url)
  results_json = JSON.parse(results.body)
  if !results_json.empty?
    (0..results_json.length - 1).each do |i|
      automation_session = results_json[i]['automation_session']
      browser_url = automation_session['browser_url'].sub! '/builds', '/dashboard/v2/builds'
      session_name = !automation_session['name'].empty? ? automation_session['name'] : automation_session['hashed_id']
      File.write('output.html', "<tr><td>#{automation_session['build_name']}</td><td>#{automation_session['project_name']}</td><td><a href=#{browser_url}>#{session_name}</a></td><td>#{automation_session['browser']}</td><td>#{automation_session['browser_version']}</td><td>#{automation_session['os']}</td><td>#{automation_session['os_version']}</td><td>#{automation_session['device']}</td><td>#{automation_session['status']}</tr>", mode: 'a')
    end
  else
    break
  end
  offset += limit
end
File.write('output.html',"</table></body></html>", mode: 'a')

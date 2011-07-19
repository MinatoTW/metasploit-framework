##
# $Id$
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##

require 'msf/core'

class Metasploit3 < Msf::Post

	def initialize(info={})
		super( update_info( info,
				'Name'          => 'Multi Manage Execute Meterpreter Console Command',
				'Description'   => %q{
						Run a Meterpreter console command against a set of
					specified sessions.
				},
				'License'       => MSF_LICENSE,
				'Author'        => [ 'Carlos Perez <carlos_perez[at]darkoperator.com>'],
				'Version'       => '$Revision$'
			))
		register_options(
			[
				OptString.new('SESSIONS', [true, 'Specify either ALL for all sessions or a comma-separated list of sessions']),
				OptString.new('COMMAND', [true, 'Meterpreter console command.', nil])
			], self.class)
	end

	# Run Method for when run command is issued
	def run

		current_sessions = framework.sessions.keys.sort

		if datastore['SESSIONS'] =~/all/i
			sessions = current_sessions
		else
			sessions = datastore['SESSIONS'].split(",")
		end

		command = datastore['COMMAND']

		sessions.each do |s|
			# Check if session is in the current session list.
			next if not current_sessions.include?(s.to_i)

			# Get session object
			session = framework.sessions.get(s.to_i)

			# Check if session is meterpreter and run command.
			if (session.type == "meterpreter")
				print_good("Running command #{command} against session #{s}")
				session.console.run_single(command)
			else
				print_error("Session #{s} is not a Meterpreter session!")
			end
		end
	end


end


defmodule Issues.GithubIssues do 

	require Logger

	@github_url Application.get_env(:issues, :github_url)	
	@user_agent [ {"User-agent", "tiago.asp.net@gmail.com"} ]	

	def fetch(user, project) do 
		Logger.info "Fetching user #{user}'s project #{project}"
		issues_url(user, project)
		|> HTTPoison.get(@user_agent)
		|> handle_response
	end	

	def issues_url(user, project) do 
		"#{@github_url}/repos/#{user}/#{project}/issues"
	end
	
	def handle_response({:error, %HTTPoison.Error{reason: error}}) do
		Logger.error "Error #{status} returned"
		{:error, error}
	end 

  	def handle_response({:ok, %HTTPoison.Response{status_code: status, body: body}}) when status >= 400 do
  		Logger.error "Error #{status} returned"
  		{:error, :jsx.decode(body)}
  	end 

  	def handle_response({:ok, %HTTPoison.Response{body: body}}) do
  		Logger.info "Successful response"
  		Logger.debug &(inspect(body))
  		{:ok, :jsx.decode(body)}
  	end 		
end 						
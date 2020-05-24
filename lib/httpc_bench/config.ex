defmodule HttpcBench.Config do
  def post_body do
    "{\"allimps\":0,\"at\":1,\"device\":{\"connectiontype\":1,\"dnt\":0,\"geo\":{\"country\":\"USA\",\"ipservice\":3,\"metro\":\"\",\"type\":2},\"h\":2436,\"ip\":\"98.0.184.114\",\"language\":\"en\",\"os\":\"android\",\"ua\":\"Mozilla/5.0 (Linux; Android 9; LM-X420 Build/PKQ1.190302.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.119 Mobile Safari/537.36\",\"w\":1125},\"id\":\"6W6M3S2E7GSGHTWJ\",\"imp\":[{\"banner\":{\"format\":[{\"h\":250,\"w\":300}],\"h\":250,\"pos\":1,\"topframe\":1,\"w\":300},\"ext\":{\"adpartner\":{\"placement_id\":26224126}},\"id\":\"1\",\"instl\":0,\"secure\":1}],\"regs\":{\"ext\":{\"gdpr\":0}},\"site\":{\"domain\":\"www.loudersound.com\",\"ext\":{\"amp\":0},\"page\":\"https://www.loudersound.com/features/tracks-of-the-week-new-music-from-ozzy-osbourne-naked-six-and-more\"},\"source\":{\"ext\":{\"schain\":{\"complete\":1,\"nodes\":[{\"asi\":\"ads.ads.com\",\"hp\":1,\"sid\":\"2eauv1id\"},{\"asi\":\"ads.info\",\"hp\":1,\"sid\":\"1133\"}],\"ver\":\"1.0\"}},\"tid\":\"6W6M3S2E7GSGHTWJ\"},\"test\":1,\"tmax\":300,\"user\":{\"ext\":{\"gdpr\":0}}}"
  end

  def bid_response do
    """
    {"id":"8d54f67e-0ea5-318e-8e96-11aab5219c1b", "cur":"USD", "seatbid":[{"bid": [{ "id":"G_7785_BC07_054672_001581945659485601029172625182", "impid":"1", "price":0.500000, "adm":"<div id=\"bks_div_ad\" style=\"display:inline-block\"><a href=\"https://ck.bucksense.com/ts_c?ts8=80172&amp;ts7=7959&amp;token=ODAxNzJ8MTgzNTd8NHwqfCp8SVR8MTA4Mzd8MTczMXwxMTI4fDF8MTF8NTYyNzF8MXwzNTU1%0AfDUyfCp8OTEuMjEzLjE1My4xMzN8KnwqfCp8KnwqfCp8KnwxfHJ1Ymljb25fMTY5NDR8cnVi%0AaWNvbl8xNTI4NDh8VF83OTU5X0JDMDdfMDU0NjcyXzAwMTU4MTk0NTY1OTQ4NTYwMTAyOTE3%0AMjYyNTE4MkBkZWNjYW5oZXJhbGQuY29tfHI1ZTQ2NWQwYTc2YzUzdXwxMjQ%3D&amp;ts90=T_7959_BC07_054672_001581945659485601029172625182\" target=\"_top\"><img src=\"https://us.bksn.se/s/18357/r5e465d0a76c53u.gif\" /></a><img src=\"https://win-us-east.bkserving.com/grindrbulk_win?price=${AUCTION_PRICE}&cid=54672&uid=6166323530333833373266623137656636643466623965383161356563333236&bcp=6179797B05306167&comp=4&session_bid_id=G_7785_BC07_054672_001581945659485601029172625182\" style=\"display:none;\" id=\"bksimpression\"/></div><script id=\"bksviewability\" src=\"https://j.bksn.se/viewability.js?ver=1&elemid=bks_div_ad&urlv=https%3A%2F%2Fck.bucksense.com%2Ftrackev%3Fbid_session_id%3DG_7785_BC07_054672_001581945659485601029172625182%26uid%3DEaC2FW68&perc=30&sec=2&width=300&cid=54672&cache=2020021708&place=4rubicon_152848&comp=4&vendor=0&prc=${AUCTION_PRICE}&site=deccanherald.com\"></script><script type='text/javascript'>!function(){bks_url=window.location;var t=document.createElement(\"script\"),e=\"https:\"==document.location.protocol?\"https://retargeting.bksn.se\":\"http://retargeting.bksn.se\";t.setAttribute(\"async\",\"true\"),t.type=\"text/javascript\",t.src=e+\"/webr?url=\"+bks_url,t.id=\"bksretarget\",(document.getElementsByTagName(\"body\")[0]||[null]||document.getElementsByTagName(\"script\")[0].parentNode||document.getElementsByTagName(\"body\")[0]||[null]).appendChild(t)}();</script>", "adomain":["bucksense.com"], "nurl":"https://win-us-east.bkserving.com/grindrbulk_win?price=${AUCTION_PRICE}&cid=54672&uid=6166323530333833373266623137656636643466623965383161356563333236&bcp=6179797B05306167&comp=4&session_bid_id=G_7785_BC07_054672_001581945659485601029172625182&nobilling=1", "crid":"r5e465d0a76c53u", "cid":"54672", "attr":[16], "cat":["IAB18-6"]}], "seat":"4"}]}
    """
  end

  @iterations Application.get_env(:httpc_bench, :iterations)

  def iterations do
    @iterations
  end

  @concurrencies Application.get_env(:httpc_bench, :concurrencies)

  def concurrencies do
    @concurrencies
  end

  @pool_sizes Application.get_env(:httpc_bench, :pool_sizes)

  def pool_sizes do
    @pool_sizes
  end

  @pool_counts Application.get_env(:httpc_bench, :pool_counts)

  def pool_counts do
    @pool_counts
  end

  @clients Application.get_env(:httpc_bench, :clients)

  def clients do
    @clients
  end

  @port Application.get_env(:httpc_bench, :port)

  def port do
    @port
  end

  @host Application.get_env(:httpc_bench, :host)

  def host do
    @host
  end

  @path Application.get_env(:httpc_bench, :path)

  def path do
    @path
  end

  def url do
    "https://#{@host}:#{@port}#{@path}"
  end

  @buoy_url {:buoy_url, "#{@host}:#{@port}", @host, @path, @port, :http}

  def buoy_url do
    @buoy_url
  end

  @pipelining Application.get_env(:httpc_bench, :pipelining)

  def pipelining do
    @pipelining
  end

  @timeout Application.get_env(:httpc_bench, :timeout)

  def timeout do
    @timeout
  end

  @headers Application.get_env(:httpc_bench, :headers)

  def headers do
    @headers
  end

  def post_headers, do: [{"content-type", "application/json"}]
end

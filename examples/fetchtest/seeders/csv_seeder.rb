CSV.foreach("./seeders/list_of_urls.csv",:headers => true) do |row|
  pages << {
    url: row['url'],
    page_type: row['page_type'],
    vars: {"abc":[1,2,3], "def": "defcontent"}  
  }

  # Save pages to the job partially if record counts will be large
  max_records = 100
  save_pages(pages) if $. % max_records == 0
end


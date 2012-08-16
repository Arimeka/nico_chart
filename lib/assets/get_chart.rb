module GetChart  
   
  def page_iteration(page)
    client = YouTubeIt::Client.new   
    1.upto(100) do |x|        
      v = page.css("div#item#{ x } table tr td p strong span").text
      nico_id = page.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]

      val = v.split(',').join
      

      ch = find_by_nico_id(nico_id)
      
      if ch.nil?
        title = page.css("div#item#{ x } table tr a.watch").first.text      

        if client.videos_by(:query => title, :max_results => 1).videos == []
          youtube_id = "empty"
        else          
          youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id          
        end

        page.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
        date = $3 + '.' + $2 + '.' + $1 + ' ' + $4       

        case page
        when @favorites
          create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: 0, mylist: 0, fav: val, title: title, upload_date: date )
        when @views
          create( nico_id: nico_id, youtube_id: youtube_id, view: val, comment: 0, mylist: 0, fav: 0, title: title, upload_date: date )
        when @comments
          create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: val, mylist: 0, fav: 0, title: title, upload_date: date )
        when @mylist
          create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: 0, mylist: val, fav: 0, title: title, upload_date: date )
        end                     
          
      else
        if ch.youtube_id == "empty"
          title = page.css("div#item#{ x } table tr a.watch").first.text      

          if client.videos_by(:query => title, :max_results => 1).videos == []
            youtube_id = "empty"
          else
            if client.videos_by(:query => title, :max_results => 1).videos.first.title.include?(title)
              youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id
            else
              youtube_id = "empty"
            end
          end

          case page
          when @favorites
            ch.update_attributes( fav: val, youtube_id: youtube_id )
          when @views
            ch.update_attributes( view: val, youtube_id: youtube_id )
          when @comments
            ch.update_attributes( comment: val, youtube_id: youtube_id )
          when @mylist
            ch.update_attributes( mylist: val, youtube_id: youtube_id )
          end
        else
          case page
          when @favorites
            ch.update_attributes( fav: val )
          when @views
            ch.update_attributes( view: val )
          when @comments
            ch.update_attributes( comment: val )
          when @mylist
            ch.update_attributes( mylist: val )
          end
        end
      end
    end
  end

  def page_iteration_new(page)
    client = YouTubeIt::Client.new
    records = []
    sql = ActiveRecord::Base.connection()  
    1.upto(100) do |x|        
      v = page.css("div#item#{ x } table tr td p strong span").text
      nico_id = page.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]
      val = v.split(',').join
      title = page.css("div#item#{ x } table tr a.watch").first.text      

      if client.videos_by(:query => title, :max_results => 1).videos == []
        youtube_id = "empty"
      else          
         youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id          
      end

      page.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
      date = $3 + '.' + $2 + '.' + $1 + ' ' + $4       

      case page
        when @favorites
          records.push({ nico_id: nico_id, youtube_id: youtube_id, fav: val, title: title, upload_date: date })
        when @views
          records.push({ nico_id: nico_id, youtube_id: youtube_id, view: val, title: title, upload_date: date })
        when @comments
          records.push({ nico_id: nico_id, youtube_id: youtube_id, comment: val, title: title, upload_date: date })
        when @mylist
          records.push({ nico_id: nico_id, youtube_id: youtube_id, mylist: val, title: title, upload_date: date })
      end  
    end

    objs = []
    records.each do |item|
      objs.push("('#{item[:nico_id]}', 
                  '#{item[:youtube_id]}', 
                  coalesce((select `view` from '" + table_name + "'' where nico_id = '#{item[:nico_id]}'),'#{item[:view]}'), 
                  coalesce((select `comment` from '" + table_name + "'' where nico_id = '#{item[:nico_id]}'),'#{item[:comment]}'), 
                  coalesce((select `mylist` from '" + table_name + "'' where nico_id = '#{item[:nico_id]}'),'#{item[:mylist]}'), 
                  coalesce((select `fav` from '" + table_name + "'' where nico_id = '#{item[:nico_id]}'),'#{item[:fav]}'), 
                  '#{item[:title]}', 
                  '#{item[:upload_date]}')")
    end

    sql.execute("INSERT OR REPLACE INTO `" + table_name + "` (`nico_id`, `youtube_id`, `view`, `comment`, `mylist`, 
                `fav`, `title`, `upload_date`) VALUES " + objs.join(','))
  end

  def delete_old
    delete_all( view: 0, comment: 0, mylist: 0, fav: 0 )
  end

  def prepare
    update_all( view: 0, comment: 0, mylist: 0, fav: 0 )
  end

  def all_caching(order, limit)
    Rails.cache.fetch("#{self}.all#{order}") { all(order: order, limit: limit) }
  end

  def expire_self_all_cache
    Rails.cache.delete("#{self}.allfav DESC")
    Rails.cache.delete("#{self}.allmylist DESC")
    Rails.cache.delete("#{self}.allcomment DESC")
    Rails.cache.delete("#{self}.allview DESC")
  end    
end
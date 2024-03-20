#!/usr/bin/env ruby

(1..617).each do |i|
  length = 4 - i.to_s.length
  j = "#{'0' * length}#{i}"
  endpoint = 'https://ia801001.us.archive.org/BookReader/BookReaderImages.php'
  params = {
    'zip' => '/0/items/Quran_Tafseel-Mawdo/Quran_Tafseel-Mawdo_jp2.zip',
    'file' => "Quran_Tafseel-Mawdo_jp2/Quran_Tafseel-Mawdo_#{j}.jp2",
    'id' => 'Quran_Tafseel-Mawdo',
    'scale' => '4',
    'rotate' => '0'
  }
  url = "#{endpoint}?#{params.entries.map{|k, v| "#{k}=#{v}" }.join('&')}"
  `curl "#{url}" > "hafs-tafseel-pages/page-#{i}.jpg"`
end

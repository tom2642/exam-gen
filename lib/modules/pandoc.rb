# frozen_string_literal: true

res = PandocRuby.convert(["./#{ARGV[0]}"], '--from=docx', '--to=markdown', '--extract-media=./')
PandocRuby.convert(res, '--from=markdown', '--to=docx', '--output=./t.docx')

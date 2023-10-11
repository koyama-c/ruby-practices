#! /usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'ls_file'
require_relative 'ls_directory'

# 列数
COLUMNS_NUMBER = 3

def main
  option = ARGV.getopts('arl')

  display_files_in_directory('.', option)
end

def display_files_in_directory(directory_path, option)
  directory = LsDirectory.new(directory_path:, include_hidden_file: option['a'], reverse_order: option['r'])
  files_for_display = directory.files
  return if files_for_display.empty?

  if option['l']
    puts "total #{directory.blocks_sum}"
    print_files_details(directory, files_for_display)
  else
    print_files(files_for_display)
  end
end

def print_files(files)
  rows_number = files.length.ceildiv(COLUMNS_NUMBER)
  transposed_files = adjust_width(align_array_size(rows_number, files).each_slice(rows_number)).transpose

  transposed_files.each do |file_array|
    file_array[-1] += "\n"
    file_array.each { |f| print f }
  end
end

# 配列の各要素のサイズを揃える
def align_array_size(rows_number, files)
  (files.length % rows_number).zero? ? files : files + Array.new(rows_number - files.length % rows_number, '')
end

# 列ごとの幅を揃える
def adjust_width(file_array)
  file_array.map do |array|
    max_num = array.map(&:length).max
    array.map { |file| "#{file.ljust(max_num)}\s\s" }
  end
end

def print_files_details(directory, files_for_display)
  max_length = directory.calc_max_length_of_file_stat
  files_for_display.each do |file_name|
    file = LsFile.new(file_path: "#{directory.directory_path}/#{file_name}", stat_max_length: max_length)
    print file.detail
    puts file_name
  end
end

main

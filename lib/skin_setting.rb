#encoding:utf-8
#==============================================================================
# ■ module Skin_Setting
#------------------------------------------------------------------------------
#  用于调用皮肤信息的模块
#
#  Skin_Setting.load_setting
#
#  Skin_Setting.setting(:Name)
#==============================================================================

module Skin_Setting
  #--------------------------------------------------------------------------
  # ● 初始化（类实例变量）
  #--------------------------------------------------------------------------
  @skin_setting = { taro_taiko:{} }
  @proc = Proc.new do |line|
    text = line.chomp
    if    text.empty?        then next
    elsif text.include?("#") then next
    else
      set = /\s*(\S+?)\s*=\s*(-?\d+)\s*/ =~ text ? [$1.to_sym,$2.to_i] : nil
      next unless set
      @skin_setting[@progress][set[0]] = set[1]
    end
  end
  #--------------------------------------------------------------------------
  # ● 读取 skinset.ini 文件
  #--------------------------------------------------------------------------
  def self.load_setting
    @progress = :taro_taiko
    IO.foreach("Skin/skinset.ini") {|line| @proc.call(line) }
  end
  #--------------------------------------------------------------------------
  # ● 读取歌曲的ini文件
  #--------------------------------------------------------------------------
  def self.load_song_setting(filename)
    @progress = :song_data
    @skin_setting[@progress] = {}
    load_setting
    return
    # TODO
    return unless filename == "qilunuo" # TODO
    IO.foreach("Songs/#{filename}.ini") {|line| @proc.call(line) }
  end
  #--------------------------------------------------------------------------
  # ● 访问类实例变量
  #--------------------------------------------------------------------------
  def self.setting(key)
    @skin_setting[:song_data][key] || @skin_setting[:taro_taiko][key] || 1
  end

end

#~ Skin_Setting.load_setting
# encoding:utf-8

module Scene
  class Base

    # 主逻辑
    def main
      start
      post_start
      update until scene_changing?
      pre_terminate
      terminate
    end

    # 开始处理
    def start
    end

    # 开始后处理
    def post_start
      perform_transition
      Input.update
    end

    # 判定是否更改场景中
    def scene_changing?
      Scene.scene != self
    end

    # 更新画面
    def update
      update_basic
    end

    # 更新画面（基础）
    def update_basic
      Graphics.update
      Input.update
    end

    # 结束前处理
    def pre_terminate
    end

    # 结束处理
    def terminate
      Graphics.freeze
    end

    # 执行渐变
    def perform_transition
      Graphics.transition(transition_speed)
    end

    # 获取渐变速度
    def transition_speed
      10
    end

    # 返回前一个场景
    def return_scene
      Scene.return
    end

    # 淡出各种音效以及图像
    def fadeout_all(time = 1000)
      RPG::BGM.fade(time)
      RPG::BGS.fade(time)
      RPG::ME.fade(time)
      Graphics.fadeout(time * Graphics.frame_rate / 1000)
      RPG::BGM.stop
      RPG::BGS.stop
      RPG::ME.stop
    end
  end
end

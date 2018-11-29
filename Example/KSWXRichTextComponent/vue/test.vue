<template>
  <div class="wrapper">
    <div class="panel">
<rich-text class="text" text="<p style='color: #666; font-weight:bold; '>Weex的text组件不支持HTML富文本的展示。KSWXRichTextComponent是Weex富文本组件库，用于将普通的HTML解析成富文本，并支持<span style='display:inline-block;font-family: PingFangSC-Regular;font-size: 22px;color: white; padding:0px;margin-left: 10px;height: 44px;line-height:44px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;width:70px;text-align: center;border-radius: 10px;border-width: 0px;border-color: red;border-style: solid;background-image: linear-gradient(to left, #EF6F4C, #F3624C, #FF4A4B);'>圆角</span>、边框、渐变等非常规富文本样式。使用简单，支持<a href='someScheme://doSomeThine'>超链接</a>、行数获取、外部样式等功能。</p>"></rich-text>
    </div>
  </div>
</template>


<style scoped>
  .wrapper {
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .panel {
    width: 600px;
    border-width: 1px;
  }
  .text {
    color: #666666;
    line-height: 50px;
  }
</style>

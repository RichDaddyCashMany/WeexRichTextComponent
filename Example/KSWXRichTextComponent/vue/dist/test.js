// { "framework": "Vue" }
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(1)
	)

	/* template */
	var __vue_template__ = __webpack_require__(2)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/hjaycee/workspace/WeexRichTextComponent/Example/KSWXRichTextComponent/vue/test.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	for (var name in module) {
	__vue_options__.style[name] = module[name]
	}
	})

	module.exports = __vue_exports__
	module.exports.el = 'true'
	new Vue(module.exports)


/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = {
	  "wrapper": {
	    "flexDirection": "column",
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "panel": {
	    "width": 600,
	    "borderWidth": 1
	  },
	  "text": {
	    "color": "#666666",
	    "lineHeight": 50
	  }
	}

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["wrapper"]
	  }, [_c('div', {
	    staticClass: ["panel"]
	  }, [_c('rich-text', {
	    staticClass: ["text"],
	    attrs: {
	      "text": "<p style='color: #666; font-weight:bold; '>Weex的text组件不支持HTML富文本的展示。KSWXRichTextComponent是Weex富文本组件库，用于将普通的HTML解析成富文本，并支持<span style='display:inline-block;font-family: PingFangSC-Regular;font-size: 22px;color: white; padding:0px;margin-left: 10px;height: 44px;line-height:44px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;width:70px;text-align: center;border-radius: 10px;border-width: 0px;border-color: red;border-style: solid;background-image: linear-gradient(to left, #EF6F4C, #F3624C, #FF4A4B);'>圆角</span>、边框、渐变等非常规富文本样式。使用简单，支持<a href='someScheme://doSomeThine'>超链接</a>、行数获取、外部样式等功能。</p>"
	    }
	  })], 1)])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }
/******/ ]);
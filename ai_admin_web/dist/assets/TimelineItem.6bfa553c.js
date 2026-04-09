import{cW as t,cX as c,cY as m,cZ as n,d as x,c_ as b,c$ as $,d0 as O,bd as E,A as l,d1 as H,aU as K,d2 as M,d3 as N,av as v,d4 as d,d5 as V,d6 as W,d7 as z,d8 as u}from"./index.fc262b08.js";const f=1.25,L=t("timeline",`
 position: relative;
 width: 100%;
 display: flex;
 flex-direction: column;
 line-height: ${f};
`,[c("horizontal",`
 flex-direction: row;
 `,[m(">",[t("timeline-item",`
 flex-shrink: 0;
 padding-right: 40px;
 `,[c("dashed-line-type",[m(">",[t("timeline-item-timeline",[n("line",`
 background-image: linear-gradient(90deg, var(--n-color-start), var(--n-color-start) 50%, transparent 50%, transparent 100%);
 background-size: 10px 1px;
 `)])])]),m(">",[t("timeline-item-content",`
 margin-top: calc(var(--n-icon-size) + 12px);
 `,[m(">",[n("meta",`
 margin-top: 6px;
 margin-bottom: unset;
 `)])]),t("timeline-item-timeline",`
 width: 100%;
 height: calc(var(--n-icon-size) + 12px);
 `,[n("line",`
 left: var(--n-icon-size);
 top: calc(var(--n-icon-size) / 2 - 1px);
 right: 0px;
 width: unset;
 height: 2px;
 `)])])])])]),c("right-placement",[t("timeline-item",[t("timeline-item-content",`
 text-align: right;
 margin-right: calc(var(--n-icon-size) + 12px);
 `),t("timeline-item-timeline",`
 width: var(--n-icon-size);
 right: 0;
 `)])]),c("left-placement",[t("timeline-item",[t("timeline-item-content",`
 margin-left: calc(var(--n-icon-size) + 12px);
 `),t("timeline-item-timeline",`
 left: 0;
 `)])]),t("timeline-item",`
 position: relative;
 `,[m("&:last-child",[t("timeline-item-timeline",[n("line",`
 display: none;
 `)]),t("timeline-item-content",[n("meta",`
 margin-bottom: 0;
 `)])]),t("timeline-item-content",[n("title",`
 margin: var(--n-title-margin);
 font-size: var(--n-title-font-size);
 transition: color .3s var(--n-bezier);
 font-weight: var(--n-title-font-weight);
 color: var(--n-title-text-color);
 `),n("content",`
 transition: color .3s var(--n-bezier);
 font-size: var(--n-content-font-size);
 color: var(--n-content-text-color);
 `),n("meta",`
 transition: color .3s var(--n-bezier);
 font-size: 12px;
 margin-top: 6px;
 margin-bottom: 20px;
 color: var(--n-meta-text-color);
 `)]),c("dashed-line-type",[t("timeline-item-timeline",[n("line",`
 --n-color-start: var(--n-line-color);
 transition: --n-color-start .3s var(--n-bezier);
 background-color: transparent;
 background-image: linear-gradient(180deg, var(--n-color-start), var(--n-color-start) 50%, transparent 50%, transparent 100%);
 background-size: 1px 10px;
 `)])]),t("timeline-item-timeline",`
 width: calc(var(--n-icon-size) + 12px);
 position: absolute;
 top: calc(var(--n-title-font-size) * ${f} / 2 - var(--n-icon-size) / 2);
 height: 100%;
 `,[n("circle",`
 border: var(--n-circle-border);
 transition:
 background-color .3s var(--n-bezier),
 border-color .3s var(--n-bezier);
 width: var(--n-icon-size);
 height: var(--n-icon-size);
 border-radius: var(--n-icon-size);
 box-sizing: border-box;
 `),n("icon",`
 color: var(--n-icon-color);
 font-size: var(--n-icon-size);
 height: var(--n-icon-size);
 width: var(--n-icon-size);
 display: flex;
 align-items: center;
 justify-content: center;
 `),n("line",`
 transition: background-color .3s var(--n-bezier);
 position: absolute;
 top: var(--n-icon-size);
 left: calc(var(--n-icon-size) / 2 - 1px);
 bottom: 0px;
 width: 2px;
 background-color: var(--n-line-color);
 `)])])]),A=Object.assign(Object.assign({},$.props),{horizontal:Boolean,itemPlacement:{type:String,default:"left"},size:{type:String,default:"medium"},iconSize:Number}),y=H("n-timeline"),X=x({name:"Timeline",props:A,setup(e,{slots:o}){const{mergedClsPrefixRef:r}=b(e),s=$("Timeline","-timeline",L,O,e,r);return E(y,{props:e,mergedThemeRef:s,mergedClsPrefixRef:r}),()=>{const{value:i}=r;return l("div",{class:[`${i}-timeline`,e.horizontal&&`${i}-timeline--horizontal`,`${i}-timeline--${e.size}-size`,!e.horizontal&&`${i}-timeline--${e.itemPlacement}-placement`]},o)}}}),D={time:[String,Number],title:String,content:String,color:String,lineType:{type:String,default:"default"},type:{type:String,default:"default"}},Y=x({name:"TimelineItem",props:D,slots:Object,setup(e){const o=K(y);o||M("timeline-item","`n-timeline-item` must be placed inside `n-timeline`."),N();const{inlineThemeDisabled:r}=b(),s=v(()=>{const{props:{size:a,iconSize:g},mergedThemeRef:p}=o,{type:h}=e,{self:{titleTextColor:_,contentTextColor:C,metaTextColor:S,lineColor:T,titleFontWeight:w,contentFontSize:P,[d("iconSize",a)]:k,[d("titleMargin",a)]:R,[d("titleFontSize",a)]:j,[d("circleBorder",h)]:B,[d("iconColor",h)]:I},common:{cubicBezierEaseInOut:F}}=p.value;return{"--n-bezier":F,"--n-circle-border":B,"--n-icon-color":I,"--n-content-font-size":P,"--n-content-text-color":C,"--n-line-color":T,"--n-meta-text-color":S,"--n-title-font-size":j,"--n-title-font-weight":w,"--n-title-margin":R,"--n-title-text-color":_,"--n-icon-size":V(g)||k}}),i=r?W("timeline-item",v(()=>{const{props:{size:a,iconSize:g}}=o,{type:p}=e;return`${a[0]}${g||"a"}${p[0]}`}),s,o.props):void 0;return{mergedClsPrefix:o.mergedClsPrefixRef,cssVars:r?void 0:s,themeClass:i==null?void 0:i.themeClass,onRender:i==null?void 0:i.onRender}},render(){const{mergedClsPrefix:e,color:o,onRender:r,$slots:s}=this;return r==null||r(),l("div",{class:[`${e}-timeline-item`,this.themeClass,`${e}-timeline-item--${this.type}-type`,`${e}-timeline-item--${this.lineType}-line-type`],style:this.cssVars},l("div",{class:`${e}-timeline-item-timeline`},l("div",{class:`${e}-timeline-item-timeline__line`}),z(s.icon,i=>i?l("div",{class:`${e}-timeline-item-timeline__icon`,style:{color:o}},i):l("div",{class:`${e}-timeline-item-timeline__circle`,style:{borderColor:o}}))),l("div",{class:`${e}-timeline-item-content`},z(s.header,i=>i||this.title?l("div",{class:`${e}-timeline-item-content__title`},i||this.title):null),l("div",{class:`${e}-timeline-item-content__content`},u(s.default,()=>[this.content])),l("div",{class:`${e}-timeline-item-content__meta`},u(s.footer,()=>[this.time]))))}});export{Y as _,X as a};

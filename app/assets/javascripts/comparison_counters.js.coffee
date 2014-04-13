$(document).ready ->

  comparisons = $('.comparison_container')

  setValues = () ->
    for data in comparisons
      comparison_data = $(data).find('.comparison_div').data('comparison')
      $(data).find(".data_paragraph").append(comparison_data)

  setValues()

  $("#top_slider").owlCarousel(
    singleItem: true,
    itemsScaleUp: false,
    slideSpeed: 500,
    paginationSpeed: 800,
    rewindSpeed: 1000,
    autoPlay: true,
    stopOnHover: false,
    navigation: false,
    navigationText: ["<",">"],
    rewindNav: true,
    scrollPerPage: false,
    pagination: true,
    paginationNumbers:false,
    responsive:true,
    responsiveRefreshRate: 200,
    responsiveBaseWidth:window,
    baseClass: "owl-carousel",
    theme: "owl-theme",
    lazyLoad: false,
    lazyFollow: true,
    lazyEffect: "fade",
    autoHeight: false,
    jsonPath: false, 
    jsonSuccess: false,
    dragBeforeAnimFinish: true,
    mouseDrag: true,
    touchDrag: true,
    transitionStyle: false,
    addClassActive: false,
    beforeUpdate: false,
    afterUpdate: false,
    beforeInit:false, 
    afterInit:false, 
    beforeMove:false, 
    afterMove:false,
    afterAction:false,
    startDragging: false,
    afterLazyLoad: false
    );

  $("#graph_carousel").owlCarousel(
    singleItem: true,
    itemsScaleUp: false,
    slideSpeed: 500,
    paginationSpeed: 800,
    rewindSpeed: 1000,
    autoPlay: true,
    stopOnHover: false,
    navigation: false,
    navigationText: ["<",">"],
    rewindNav: true,
    scrollPerPage: false,
    pagination: true,
    paginationNumbers:false,
    responsive:true,
    responsiveRefreshRate: 200,
    responsiveBaseWidth:window,
    baseClass: "owl-carousel",
    theme: "owl-theme",
    lazyLoad: false,
    lazyFollow: true,
    lazyEffect: "fade",
    autoHeight: false,
    jsonPath: false, 
    jsonSuccess: false,
    dragBeforeAnimFinish: true,
    mouseDrag: true,
    touchDrag: true,
    transitionStyle: false,
    addClassActive: false,
    beforeUpdate: false,
    afterUpdate: false,
    beforeInit:false, 
    afterInit:false, 
    beforeMove:false, 
    afterMove:false,
    afterAction:false,
    startDragging: false,
    afterLazyLoad: false
    );
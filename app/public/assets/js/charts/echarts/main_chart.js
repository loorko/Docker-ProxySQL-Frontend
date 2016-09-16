/* ------------------------------------------------------------------------------
 *
 *  # Echarts - columns and waterfalls
 *
 *  Columns and waterfalls chart configurations
 *
 *  Version: 1.0
 *  Latest update: August 1, 2015
 *
 * ---------------------------------------------------------------------------- */

$(function () {

    // Set paths
    // ------------------------------

    require.config({
        paths: {
            echarts: '../assets/js/plugins/visualization/echarts'
        }
    });


    // Configuration
    // ------------------------------

    require(
        [
            'echarts',
            'echarts/theme/limitless',
            'echarts/chart/bar',
            'echarts/chart/pie'
        ],


        // Charts setup
        function (ec, limitless) {


            // Initialize charts
            // ------------------------------

            var basic_donut = ec.init(document.getElementById('basic_donut'), limitless);
            var basic_bar = ec.init(document.getElementById('basic_bar'), limitless);

            // Charts setup
            // ------------------------------
            //
            
            //
            // Basic donut options
            //

            basic_donut_options = {

                // Add legend
                legend: {
                    orient: 'vertical',
                    x: 'left',
                    data: ['Foglalt','Előfoglalt','Szabad']
                },

                // Add series
                series: [
                    {
                        name: 'Browsers',
                        type: 'pie',
                        radius: ['50%', '70%'],
                        center: ['50%', '57.5%'],
                        itemStyle: {
                            normal: {
                                label: {
                                    show: true
                                },
                                labelLine: {
                                    show: true
                                }
                            },
                            emphasis: {
                                label: {
                                    show: true,
                                    formatter: '{b}' + '\n\n' + '{c} ({d}%)',
                                    position: 'center',
                                    textStyle: {
                                        fontSize: '17',
                                        fontWeight: '500'
                                    }
                                }
                            }
                        },

                        data: [
                            {value: 335, name: 'Foglalt'},
                            {value: 310, name: 'Előfoglalt'},
                            {value: 234, name: 'Szabad'},
                        ]
                    }
                ]
            };
            
            // Basic bar options
            //

            basic_bar_options = {

                // Setup grid
                grid: {
                    x: 40,
                    x2: 40,
                    y: 35,
                    y2: 25
                },

                // Add tooltip
                tooltip: {
                    trigger: 'axis'
                },

                // Horizontal axis
                xAxis: [{
                    type: 'category',
                    data: ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep']
                }],

                // Vertical axis
                yAxis: [{
                    type: 'value'
                }],

                // Add series
                series: [
                    {
                        name: 'Vendég',
                        type: 'bar',
                        data: [123, 121, 234, 345, 321, 432, 456, 532, 467, 432, 342, 378],
                        itemStyle: {
                            normal: {
                                label: {
                                    show: true,
                                    textStyle: {
                                        fontWeight: 500
                                    }
                                }
                            }
                        },
                        markLine: {
                            data: [{type: 'average', name: 'Average'}]
                        }
                    }
                ]
            };


            // Apply options
            // ------------------------------
            basic_donut.setOption(basic_donut_options);
            basic_bar.setOption(basic_bar_options);

            // Resize charts
            // ------------------------------

            window.onresize = function () {
                setTimeout(function () {
                    basic_donut.resize();
                    basic_bar.resize();
                }, 200);
            };
        }
    );
});

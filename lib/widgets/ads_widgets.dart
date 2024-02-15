import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/Ads.provider.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {

  @override
  void initState() {
    Provider.of<AdsProvider>(context, listen: false).initCarousel();
    init();
    super.initState();

  }

  void init() async {
    await Provider.of<AdsProvider>(context, listen: false).getAds();
  }

  @override
  void dispose() {
    Provider.of<AdsProvider>(context, listen: false).disposeCarousel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
        builder: (ctx, adProvider, _) => adProvider.adsList == null
            ? CircularProgressIndicator()
            : (adProvider.adsList?.isEmpty ?? false)
                ? const Text('No Data Found')
                : Column(
                    children: [
                      CarouselSlider(
                        carouselController: adProvider.carouselController,
                        options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            viewportFraction: 0.75,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            onPageChanged: (index, _) =>
                                adProvider.onPageChanged(index),
                            enlargeStrategy: CenterPageEnlargeStrategy.height),
                        items: adProvider.adsList!.map((ads) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(ads.image.toString()))),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  child: Text(
                                      style: const TextStyle(
                                          backgroundColor: Colors.black38,
                                          color: Colors.white),
                                      ads.title.toString())),
                            ),
                          );
                        }).toList(),
                      ),
                      Row(
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () async {
                                await adProvider.carouselController?.nextPage();
                                setState(() {});
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          IconButton(
                              onPressed: () async {
                                await adProvider.carouselController
                                    ?.previousPage();
                                setState(() {});
                              },
                              icon: const Icon(Icons.arrow_forward_ios))
                        ],
                      ),
                      DotsIndicator(
                        dotsCount: adProvider.adsList!.length,
                        position: adProvider.sliderIndex,
                        onTap: (position) => adProvider.onDotTapped(position),
                        decorator: DotsDecorator(
                          activeColor: Colors.deepOrange,
                          size: const Size.square(9.0),
                          activeSize: const Size(18.0, 9.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ],
                  ));
  }
}

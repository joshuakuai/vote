#ifndef LOCATIONCALCULATOR_H_
#define LOCATIONCALCULATOR_H_

#include <math.h>

#define EARTH_RADIUS 6378.137;

class LocationCalculator {
public:
	static double calculateDistance(double longitudeA, double latitudeA,
			double longitudeB, double latitudeB) {
		double radLatA = LocationCalculator::rad(latitudeA);
		double radLatB = LocationCalculator::rad(latitudeB);
		double radLogA = LocationCalculator::rad(longitudeA);
		double radLogB = LocationCalculator::rad(longitudeB);

		double latSub = radLatA - radLatB;
		double logSub = radLogA - radLogB;

		double s = 2 * asin(sqrt(pow(sin(latSub / 2), 2)))
				+ cos(radLatA) * cos(radLatB) * pow(sin(logSub / 2), 2);
		s *= EARTH_RADIUS;
		s = round(s*10000)/10000;

		return s;
	}

	static double rad(double d) {
		return d * M_PI / 180;
	}
};

#endif

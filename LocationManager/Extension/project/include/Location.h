#ifndef Location_H_
#define Location_H_

struct Location{
	Location(float inAlt=0, float inLat=0, float inLon=0, float inCourse=0, float inHorzAcc=0, float inSpeed=0, float inTimestamp=0, float inVertAcc=0)
	:altitude(inAlt), latitude(inLat), longitude(inLon), course(inCourse), horizontalAccuracy(inHorzAcc), speed(inSpeed), timestamp(inTimestamp), verticalAccuracy(inVertAcc){}
	
	float altitude;
	float latitude;
	float longitude;
	float course;
	float horizontalAccuracy;
	float speed;
	float timestamp;
	float verticalAccuracy;
};


#endif
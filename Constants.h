typedef enum {
    kLineShape  = 0,
    kRectShape,
    kEllipseShape,
    kImageShape
} ShapeType;

typedef enum {
    kRedColorTab = 0,
    kBlueColorTab,
    kYellowColorTab,
    kGreenColorTab,
    kRandomColorTab
} ColorTabIndex;
#define degreesToRadian(x) (M_PI * (x) / 180.0)


NSString *const BackendChargeURLString = @"https://aqueous-harbor-4077.herokuapp.com/"; // TODO: replace nil with your own value
//: Playground - noun: a place where people can play

import UIKit


protocol Filterable {
    func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8)
}

class Filter {
    var intensity: UInt8 = 20
    
    var intensityPercent : Double {
        get {
            return Double (intensity) / Double(100)
        }
        set {
            self.intensity = UInt8(newValue)
        }
        
    }
    
    func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
    }
    
    func minMaxRGB(number: UInt8) -> UInt8{
        return UInt8(max(0, min(255, number)))
    }
}

class BrightnessFilter: Filter {
    override func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
        super.applyFilter(onPixel: &pixel, andIntensity: intensity)
        print("mpika")
        print(intensity)
        
//                let relativeLuminance = Double(pixel.red) * 0.2126 + Double(pixel.blue) * 0.0722 + Double(pixel.green) * 0.7152
                //find the amount to add based on the intensity
                /*

                let blueToCalc = pixel.blue * intensityPercent
                let redToCalc = pixel.red * intensityPercent
                let greenToCalc = pixel.green * intensityPercent
        
                if intensity < 0 {
                    
                    pixel.green = minMaxRGB(pixel.green - greenToCalc)
                    pixel.red = minMaxRGB(pixel.red - redToCalc)
                    pixel.blue = minMaxRGB(pixel.blue - blueToCalc)
                } else {
                    pixel.green = minMaxRGB(pixel.green + greenToCalc)
                    pixel.red = minMaxRGB(pixel.red + redToCalc)
                    pixel.blue = minMaxRGB(pixel.blue + blueToCalc)
                }
*/
        

    }
    
}

class ContrastFilter: Filter {

    override func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
        super.applyFilter(onPixel: &pixel, andIntensity: intensity)
        
        

    }
    
}

class GrayscaleFilter: Filter {
    override func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
        super.applyFilter(onPixel: &pixel, andIntensity: intensity)

        let grayScaleBlue = Double(pixel.blue) * 0.114
        let grayScaleGreen = Double(pixel.green) * 0.587
        let grayScaleRed = Double(pixel.red) * 0.299
                
        pixel.red = UInt8(grayScaleRed)
        pixel.blue = UInt8(grayScaleBlue)
        pixel.green = UInt8(grayScaleGreen)
    }
}


class GreenFilter: Filter {
    override func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
        super.applyFilter(onPixel: &pixel, andIntensity: intensity)

        pixel.green = UInt8(max(0, min(255, intensity)))
        
    }
}

class RedFilter: Filter {
    override func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
        super.applyFilter(onPixel: &pixel, andIntensity: intensity)
        pixel.red = UInt8(max(0, min(255, intensity)))
    
    }
}

class BlueFilter: Filter {
    override func applyFilter(inout onPixel pixel: Pixel, andIntensity intensity: UInt8) {
        super.applyFilter(onPixel: &pixel, andIntensity: intensity)
        
        pixel.blue = UInt8(max(0, min(255, intensity)))
    }
}


class ImageProcessor {
    
    var image: UIImage? = nil
    var rgbaImage: RGBAImage?
    
    var filtersByName: [String: Filter] = [
        "blue" : BlueFilter(),
        "red" : RedFilter(),
        "green" : GreenFilter(),
        "grayscale" : GrayscaleFilter(),
        "brightness" : BrightnessFilter()
    ];
    var filters: [Filter]
    
    init(withImage imageName:String) {
        self.image = UIImage(named: imageName)!
        if self.image != nil {
            self.rgbaImage = RGBAImage(image: self.image!)!
        }
        self.filters = []
    }
    
    func addFilter(aFilter: Filter) {
        self.filters.append(aFilter)
    }
    
    func applyFilters(filtersArr: [Filter]) {
        for y in 0..<self.rgbaImage!.height {
            for x in 0..<self.rgbaImage!.width {
                
                let index = y * self.rgbaImage!.width + x
                var pixel = self.rgbaImage!.pixels[index]
                for filter in self.filters {
                    filter.applyFilter(onPixel: &pixel, andIntensity: filter.intensity)
                    self.rgbaImage!.pixels[index] = pixel
                }
                
            }
        }
    }
}

let imageProcess = ImageProcessor(withImage: "sample")

imageProcess.image

let green = GreenFilter()
green.intensity = 255

let blue = BlueFilter()
blue.intensity = 255

let red = RedFilter()
red.intensity = 255

//let lighten = BrightnessFilter()
//lighten.intensity = 20
//imageProcess.addFilter(lighten)

//let grayscaleFilter = Grayscale()
//imageProcess.addFilter(grayscaleFilter)

imageProcess.addFilter(green)
imageProcess.addFilter(blue)
imageProcess.addFilter(red)

//apply all the filters
imageProcess.applyFilters(imageProcess.filters)
let newImage = imageProcess.rgbaImage?.toUIImage()


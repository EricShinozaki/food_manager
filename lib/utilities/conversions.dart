class MeasurementConverter {
  MeasurementConverter();

  double convert(String convertFrom, String convertTo){
      switch(convertFrom){
        case 'tsp':
          switch(convertTo){
            case 'tbsp':
              return 0.33333333;
            case 'cup':
              return 0.02083333;
            case 'pint':
              return 0.01041666;
            case 'quart':
              return 0.00520833;
            case 'gallon':
              return 0.001302083;
          }
        case 'tbsp':
          switch(convertTo){
            case 'tsp':
              return 3;
            case 'cup':
              return 0.0625;
            case 'pint':
              return 0.03125;
            case 'quart':
              return 0.015625;
            case 'gallon':
              return 0.00390625;
          }
        case 'cup':
          switch(convertTo){
            case 'tsp':
              return 48;
            case 'tbsp':
              return 16;
            case 'pint':
              return 0.5;
            case 'quart':
              return 0.25;
            case 'gallon':
              return 0.0625;
          }
        case 'pint':
          switch(convertTo){
            case 'tsp':
              return 96;
            case 'tbsp':
              return 32;
            case 'cup':
              return 2;
            case 'quart':
              return 0.5;
            case 'gallon':
              return 0.125;
          }
        case 'quart':
          switch(convertTo){
            case 'tsp':
              return 192;
            case 'tbsp':
              return 64;
            case 'cup':
              return 4;
            case 'pint':
              return 2;
            case 'gallon':
              return 1/4;
          }
        case 'gallon':
          switch(convertTo){
            case 'tsp':
              return 768;
            case 'tbsp':
              return 256;
            case 'cup':
              return 16;
            case 'pint':
              return 8;
            case 'quart':
              return 4;
          }
        case 'oz':
          if(convertTo == 'lb'){
            return 0.0625;
          }
        case 'lb':
          if(convertTo == 'oz'){
            return 16;
          }
        default:
          return 1;
      }

      return 1;
  }
}
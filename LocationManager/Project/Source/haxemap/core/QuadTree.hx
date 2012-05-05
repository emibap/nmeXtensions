/*******************************************************************************
Copyright (c) 2010, Karel Slany (slany AT fit.vutbr.cz)

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the organization nor the names of its
      contributors may be used to endorse or promote products derived from this
      software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE. 
*******************************************************************************/

package haxemap.core;

typedef QuadData = {
  public var x:Float;
  public var y:Float;
  public var data:Dynamic;
}

class QuadLeaf {
  public var x:Float;
  public var y:Float;
  public var data:Array<Dynamic>;
  public var ll:Dynamic; // <  x, <  y
  public var lg:Dynamic; // <  x, >= y
  public var gl:Dynamic; // >= x, <  y
  public var gg:Dynamic; // >= x, >= y

  public function new(xv:Float, yv:Float, d:Dynamic, optfast:Bool) {
    x = xv;
    y = yv;
    data = new Array<Dynamic>();
    if (optfast) {
       var qd:QuadData = {x:xv, y:yv, data:d};
       data.push(qd);
    } else {
       data.push(d);
    }
    ll = lg = gl = gg = null;
  }

  public function push(d:Dynamic, optfast:Bool) {
    if (optfast) {
       var qd:QuadData = {x:x, y:y, data:d};
       data.push(qd);
    } else {
       data.push(data);
    }
  }

  public function remove(d:Dynamic, optfast:Bool):Bool {
    if (optfast) {
       for (itm in data)
           if (itm.data == d)
                return data.remove(itm);
    } else {
       return data.remove(d);
    }
    return false;
  }

  public function getData(data:Array<QuadData>, optfast:Bool, filter:QuadData->Bool) {
    var qd:QuadData = null;// = {x:0.0, y:0.0, data:null};
    if (optfast) {
       for (qd in this.data) {
           if ((filter == null) || (filter(qd)))
              data.push(qd);
       }
    } else {
       for (i in 0...this.data.length) {
           qd.x = x;
           qd.y = y;
           qd.data = this.data[i];
           if ((filter == null) || (filter(qd)))
              data.push(qd);
       }
    }
  }
}

class QuadTree {

  public var qroot:Dynamic;
  var optfast:Bool;

  public function new() {
    optfast = true; //true - optimized for maximal speed, 
                    //false - optimized for mimimal memory footprint
    qroot = null;
  }

  /*============================================================================================== 
    PUBLIC methods
   *==============================================================================================*/
  public function clear() {
    qroot = null;
  }

  public function isEmpty() {
    return qroot == null;
  }

  public function push(x:Float, y:Float, data:Dynamic) {
    if (qroot != null) {
      push_recursive(qroot, x, y, data);
    } else {
      qroot = new QuadLeaf(x, y, data, optfast);
    }
  }

  public function remove(x:Float, y:Float, data:Dynamic) : Bool {
    // return true if found and removed
    if (qroot != null) {
      return remove_recursive(qroot, x, y, data);
    }
    return false;
  }

  public function getData(minx:Float, miny:Float, maxx:Float, maxy:Float) : Array<QuadData> {
    var data = new Array<QuadData>();
    if (qroot == null) return data;
    get_data_recursive(qroot, data, minx, miny, maxx, maxy, null);
    return data;
  }

  public function getFilteredData(minx:Float, miny:Float, maxx:Float, maxy:Float, filter:QuadData->Bool) : Array<QuadData> {
    var data = new Array<QuadData>();
    if (qroot == null) return data;
    get_data_recursive(qroot, data, minx, miny, maxx, maxy, filter);
    return data;
  }

  /*============================================================================================== 
    PRIVATE methods
   *==============================================================================================*/

  function push_recursive(root:QuadLeaf, x:Float, y:Float, data:Dynamic) {
    if ((x == root.x) && (y == root.y)) {
      // allows multiple entries
      root.push(data, optfast);
    } else if (x < root.x) {
      if (y < root.y) {
        if (root.ll != null) {
          push_recursive(root.ll, x, y, data);
	} else {
          root.ll = new QuadLeaf(x, y, data, optfast);
        }
      } else {
        if (root.lg != null) {
          push_recursive(root.lg, x, y, data);
        } else {
          root.lg = new QuadLeaf(x, y, data, optfast);
        }
      }
    } else {
      if (y < root.y) {
        if (root.gl != null) {
          push_recursive(root.gl, x, y, data);
        } else {
          root.gl = new QuadLeaf(x, y, data, optfast);
        }
      } else {
        if (root.gg != null) {
          push_recursive(root.gg, x, y, data);
        } else {
          root.gg = new QuadLeaf(x, y, data, optfast);
        }
      }
    }
  }

  function remove_recursive(root:QuadLeaf, x:Float, y:Float, data:Dynamic) : Bool {
    // does not remove nodes, only removes data entries
    if ((x == root.x) && (y == root.y)) {
      return root.remove(data, optfast);
    } else if (x < root.x) {
      if (y < root.y) {
        if (root.ll != null) {
          return remove_recursive(root.ll, x, y, data);
        }
        return false;
      } else {
        if (root.lg != null) {
          return remove_recursive(root.lg, x, y, data);
        }
        return false;
      }
    } else {
      if (y < root.y) {
        if (root.gl != null) {
          return remove_recursive(root.gl, x, y, data);
        }
        return false;
      } else {
        if (root.gg != null) {
          return remove_recursive(root.gg, x, y, data);
        }
        return false;
      }
    }
  }

  function get_data_recursive(root:QuadLeaf, data:Array<QuadData>, minx:Float, miny:Float, maxx:Float, maxy:Float, filter:QuadData->Bool) {
    if ((minx <= root.x) && (miny <= root.y) && (maxx >= root.x) && (maxy >= root.y)) {
       root.getData(data, optfast, filter);
    }
    if ((root.ll != null) && (minx <= root.x) && (miny <= root.y)) {
      get_data_recursive(root.ll, data, minx, miny, maxx, maxy, filter);
    }
    if ((root.lg != null) && (minx <= root.x) && (maxy >= root.y)) {
      get_data_recursive(root.lg, data, minx, miny, maxx, maxy, filter);
    }
    if ((root.gl != null) && (maxx >= root.x) && (miny <= root.y)) {
      get_data_recursive(root.gl, data, minx, miny, maxx, maxy, filter);
    }
    if ((root.gg != null) && (maxx >= root.x) && (maxy >= root.y)) {
      get_data_recursive(root.gg, data, minx, miny, maxx, maxy, filter);
    }
  }

}

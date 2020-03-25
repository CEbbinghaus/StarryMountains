import 'dart:math';

class Vector2 {
	double x;
	double y;

	static Vector2 get zero{
		return Vector2(0, 0);
	}

	static Vector2 get one{
		return Vector2(1, 1);
	}

	static Vector2 get right{
		return Vector2(1, 0);
	}

	static Vector2 get up{
		return Vector2(0, 1);
	}

	double get Magnitude {
		return sqrt(x * x + y * y);
	}

	Vector2 get Normalized {
		return this / Magnitude;
	}

	Vector2([x, y]) {

		if (y == null) {
			if(x is num){
				this.y = this.x = x.toDouble();
				return;
			}else if(x is Vector2){
				this.x = x.x;
				this.y = x.y;
				return;
			}else if(x == null){
				this.x = this.y = 0.toDouble();
			}
		}else if(x is num && y is num){
			this.x = x.toDouble();
			this.y = y.toDouble();
			return;
		}else throw "Undefined Constructor Arguments (${x.runtimeType}, ${y.runtimeType})";
	}

  Vector2.fromPoint(Point p){
    this.x = p.x;
    this.y = p.y;
  }

	Vector2 Normalize() {
		double m = Magnitude;
    if(m == 0)return this;
		x /= m;
		y /= m;
		return this;
	}

	Vector2 operator *(other) {
		if (other is Vector2) return Vector2(x * other.x, y * other.y);
		if (other is num) return Vector2(x * other, y * other);
		throw "Cannot Multiply Vector3 with ${other.runtimeType}";
	}

	Vector2 operator /(other) {
		if (other is Vector2) return Vector2(x / other.x, y / other.y);
		if (other is num){
      if(other == 0)return this;
      return Vector2(x / other, y / other);
    }
		throw "Cannot Multiply Vector3 with ${other.runtimeType}";
	}

	Vector2 operator +(Vector2 other) {
		return Vector2(x + other.x, y + other.y);
	}


	Vector2 operator -(Vector2 other) {
		return Vector2(x - other.x, y - other.y);
	}
	
	bool operator ==(covariant Vector2 other){
		return x == other.x && y == other.y;
	}

	Vector2 operator-(){
		x = -x;
		y = -y;
		return this;
	}

	@override
	String toString() {
		return 'Vector2($x, $y)';
	}
}

class Vector3 {
	double x;
	double y;
	double z;

	double get Magnitude {
		return sqrt(x * x + y * y + z * z);
	}

	Vector3 get Normalized {
		return this / Magnitude;
	}

	static Vector3 get one {
		return Vector3(1, 1, 1);
	}

	static Vector3 get zero {
		return Vector3(0, 0, 0);
	}

	static Vector3 get right{
		return Vector3(1, 0, 0);
	}

	static Vector3 get up{
		return Vector3(0, 1, 0);
	}

	static Vector3 get forward{
		return Vector3(0, 0, 1);
	}

	static Vector3 TriNormal(Vector3 a, Vector3 b, Vector3 c){
		return Vector3.cross(b - a, c - a);
	}

	static Vector3 cross(Vector3 a, Vector3 b){
		return Vector3(
			a.y * b.z - a.z * b.y,
			a.z * b.x - a.x * b.z,
			a.x * b.y - a.y * b.x
		);
	}
 
	Vector3([x, y, z]) {
		if(y == null && z == null){
			if (x is Vector3) {
				this.x = x.x;
				this.y = x.y;
				this.z = x.z;
			}else if(x is num){
				this.x = this.y = this.z = x.toDouble();
			}else if(x == null){
				this.x = this.y = this.z = 0.toDouble();
			}
		} else if (x is Vector2 && y is num) {
			this.x = x.x;
			this.y = x.y;
			this.z = y.toDouble();
		} else if (y is Vector2 && x is num) {
			this.x = x.toDouble();
			this.y = y.x;
			this.z = y.y;
		} else if (x is num && y is num && z is num) {
			this.x = x.toDouble();
			this.y = y.toDouble();
			this.z = z.toDouble();
		} else {
			throw "Undefined Constructor Arguments (${x.runtimeType}, ${y.runtimeType}, ${z.runtimeType})";
		}
	}

	Vector3 Normalize() {
		double m = Magnitude;
    if(m == 0)return this;
		x /= m;
		y /= m;
		z /= m;
		return this;
	}

	Vector3 operator *(other) {
		if (other is Vector3) return Vector3(x * other.x, y * other.y, z * other.z);
		if (other is num) return Vector3(x * other, y * other, z * other);
		throw "Cannot Multiply Vector3 with ${other.runtimeType}";
	}

	Vector3 operator /(other) {
		if (other is Vector3) return Vector3(x / other.x, y / other.y, z / other.z);
		if (other is num){
      if(other == 0)return this;
      return Vector3(x / other, y / other, z / other);
    }
		throw "Cannot Multiply Vector3 with ${other.runtimeType}";
	}

	Vector3 operator +(Vector3 other) {
		return Vector3(x + other.x, y + other.y, z + other.z);
	}

	Vector3 operator -(Vector3 other) {
		return Vector3(x - other.x, y - other.y, z - other.z);
	}

	bool operator ==(covariant Vector3 other){
		return x == other.x && y == other.y && z == other.z;
	}

	Vector3 operator-(){
		x = -x;
		y = -y;
		z = -z;
		return this;
	}

	@override
	String toString() {
		return 'Vector3($x, $y, $z)';
	}
}

class Vector4{
	double x;
	double y;
	double z;
	double w;

	double get Magnitude {
		return sqrt(x * x + y * y + z * z + w * w);
	}
	
	Vector4 get Normalized {
		return this / Magnitude;
	}

	static Vector4 get zero {
		return Vector4(0, 0, 0, 0);
	}

	static Vector4 get one {
		return Vector4(1, 1, 1, 1);
	}

	static Vector4 get right {
		return Vector4(1, 0, 0, 0);
	}
	
	static Vector4 get up {
		return Vector4(0, 1, 0, 0);
	}
	
	static Vector4 get forward {
		return Vector4(0, 0, 1, 0);
	}
	
	static Vector4 get homogenous {
		return Vector4(0, 0, 0, 1);
	}
 
	static Vector3 TriNormal(Vector4 a, Vector4 b, Vector4 c){
		return Vector4.cross(b - a, c - a);
	}

	static Vector3 cross(Vector4 a, Vector4 b){
		return Vector3(
			a.y * b.z - a.z * b.y,
			a.z * b.x - a.x * b.z,
			a.x * b.y - a.y * b.x
		);
	}

	Vector4([x, y, z, w]) {
		if(y == null && z == null && w == null){
			if (x is Vector4) {
				this.x = x.x;
				this.y = x.y;
				this.z = x.z;
				this.w = x.w;
			}else if(x is num){
				this.x = this.y = this.z = this.w = x.toDouble();
			}else if(x == null){
				this.x = this.y = this.z = this.w = 0.toDouble();
			}
		} else if (x is Vector3 && w is num) {
			this.x = x.x;
			this.y = x.y;
			this.z = x.z;
			this.w = y.toDouble();
		} else if (y is Vector3 && x is num) {
			this.x = x.toDouble();
			this.y = y.x;
			this.z = y.y;
			this.z = y.z;
		} else if(x is Vector2 && y is Vector2){
			this.x = x.x;
			this.y = x.y;
			this.z = y.x;
			this.w = y.y;
		} else if(x is Vector2 && y is num && z is num){
			this.x = x.x;
			this.y = x.y;
			this.z = y.toDouble();
			this.w = z.toDouble();
		} else if(x is num && y is Vector2 && z is num){
			this.x = x.toDouble();
			this.y = y.x;
			this.z = y.y;
			this.w = z.toDouble();
		}else if(x is num && y is num && z is Vector2){
			this.x = x.toDouble();
			this.y = y.toDouble();
			this.z = z.x;
			this.w = z.y;
		} else if (x is num && y is num && z is num && w is num) {
			this.x = x.toDouble();
			this.y = y.toDouble();
			this.z = z.toDouble();
			this.w = w.toDouble();
		} else {
			throw "Undefined Constructor Arguments (${x.runtimeType}, ${y.runtimeType}, ${z.runtimeType}, ${w.runtimeType})";
		}
	}

	Vector4 Normalize() {
		double m = Magnitude;
    if(m == 0)return this;
		x /= m;
		y /= m;
		z /= m;
		return this;
	}

	Vector4 operator *(other) {
		if (other is Vector4) return Vector4(x * other.x, y * other.y, z * other.z, w * other.w);
		if (other is num) return Vector4(x * other, y * other, z * other, w * other);
		throw "Cannot Multiply Vector4 with ${other.runtimeType}";
	}

	Vector4 operator /(other) {
		if (other is Vector4) return Vector4(x / other.x, y / other.y, z / other.z, w / other.w);
		if (other is num){
      if(other == 0)return this;
      return Vector4(x / other, y / other, z / other, w / other);
    }
		throw "Cannot Multiply Vector4 with ${other.runtimeType}";
	}

	Vector4 operator +(Vector4 other) {
		return Vector4(x + other.x, y + other.y, z + other.z, w + other.w);
	}

	Vector4 operator -(Vector4 other) {
		return Vector4(x - other.x, y - other.y, z - other.z, w + other.w);
	}

	bool operator ==(covariant Vector4 other){
		return x == other.x && y == other.y && z == other.z && w == other.w;
	}

	Vector4 operator-(){
		x = -x;
		y = -y;
		z = -z;
		w = -w;
		return this;
	}

	@override
	String toString() {
		return 'Vector4($x, $y, $z, $w)';
	}
}
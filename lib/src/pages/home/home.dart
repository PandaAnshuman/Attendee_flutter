import 'dart:convert';
import 'dart:typed_data';

import 'package:attendee/src/global.dart';
import 'package:attendee/src/model/student_model.dart';
import 'package:attendee/src/pages/Attendance/attendance.dart';
import 'package:attendee/src/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  late String name;
  late String regdNo;
  // late String sec;

  @override
  void initState() {
    fetchStudentInfo();
    super.initState();
  }

  Uint8List? list;
  void requestImg() async {
    //login this  user and get Cookie and then call image section.
    try {
      final https.Response response = await https.get(
        Uri.parse(
            'http://115.240.101.51:8282/CampusPortalSOA/image/studentPhoto'),
        headers: {
          'Cookie': 'JSESSIONID=${sharedPreferences.getString('cookie')}',
        },
      );
      // print(profileImage);
      setState(() {
        list = response.bodyBytes;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  late Student student;

  logoutMe() async {
    await sharedPreferences.setString('cookie', '');
    await sharedPreferences.setBool('isLoggedIn', false);
  }

  fetchStudentInfo() async {
    try {
      var response = await https.post(
          Uri.parse('http://115.240.101.51:8282/CampusPortalSOA/studentinfo'),
          headers: {
            "Cookie": "JSESSIONID=${sharedPreferences.getString('cookie')}"
          });
      print(response.body);
      var decoded = jsonDecode(response.body);

      if (decoded["detail"].isEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      } else {
        student = Student(
          name: decoded["detail"][0]["name"] ?? "Not Given",
          regdNo: decoded["detail"][0]["enrollmentno"] ?? "Not given",
          dob: decoded["detail"][0]["dateofbirth"] ?? "Not given",
          branch: decoded["detail"][0]["branchdesc"] ?? "Not given",
          sec: decoded["detail"][0]["sectioncode"] ?? "Not given",
          email: decoded["detail"][0]["semailid"] ?? "Not given",
          mname: decoded["detail"][0]["mothersname"] ?? "Not given",
          address: decoded["detail"][0]["paddress3"] ?? "Not given",
          admissionyear: decoded["detail"][0]["admissionyear"] ?? "Not given",
          caddress3: decoded["detail"][0]["paddress1"] ?? "Not given",
          pNo: decoded["detail"][0]["scellno"] ?? "Not given",
          pincode: decoded["detail"][0]["ppin"] ?? "Not given",
        );
      }
      requestImg();
      setState(() {
        isLoading = false;
      });

      // setState(() {
      //   name = decoded["detail"][0]["name"];
      //   regdNo = decoded["detail"][0]["enrollmentno"];
      //   // print(sec.toString());
      //   //sec = decoded["detail"][0]["sectioncode"];
      //   isLoading = false;
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    list == null
                        ? const CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Align(
                                  child: CircleAvatar(
                                    backgroundImage: MemoryImage(list!),
                                    radius: 60,

                                    backgroundColor: Colors.red,
                                    // backgroundImage: ,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(7),
                                      child: Center(
                                        child: Text(
                                          "Name : ${student.name!}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      margin: const EdgeInsets.all(0),
                                      padding: const EdgeInsets.all(3),
                                      child: Center(
                                        child: Text(
                                          "Regd No. : ${student.regdNo!}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),

                    const SizedBox(
                      height: 40,
                    ),

                    Container(
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 0, 0, 0)),
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.all(12),
                      child: const Center(
                        child: Text(
                          'Student Information ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Color.fromARGB(255, 4, 53, 99)),
                    //   margin: const EdgeInsets.all(10),
                    //   padding: const EdgeInsets.all(10),
                    //   child: Center(
                    //     child: Text(
                    //       "Name : ${student.name!}",
                    //       style: const TextStyle(
                    //           fontSize: 20, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Color.fromARGB(255, 4, 53, 99)),
                    //   margin: const EdgeInsets.all(10),
                    //   padding: const EdgeInsets.all(10),
                    //   child: Center(
                    //     child: Text(
                    //       "Regd No. : ${student.regdNo!}",
                    //       style: const TextStyle(
                    //           fontSize: 20, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Section : ${student.sec!}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Branch : ${student.branch!}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Father's Name :${student.caddress3!}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Mother's Name : ${student.mname!}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Phone No : ${student.pNo!}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Email Id : ${student.email!}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "DOB : ${student.dob!}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Address : ${student.address!}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Pincode : ${student.pincode!.toString()}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 4, 53, 99)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "Admission Year :${student.admissionyear!}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Attendencepage()));
                          },
                          child: const Text('Get Your Attendance ')),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          onPressed: () {
                            logoutMe();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SplashScreen()));
                          },
                          child: const Text('Logout')),
                    ),
                    // Text(student.dob.toString()),
                  ],
                ),
              ),
            ),
    );
  }
}

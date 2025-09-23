import 'package:flutter/material.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF33A248), // First color (#33A248)
                  Color(0xFFB2EA50), // Second color (#B2EA50)
                ],
                begin: Alignment.topRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        title:const Text('Organization Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Our Story Journey of Impact and Transformation Through Dedicated Efforts',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Cormorant",
                )),
            const SizedBox(height: 8.0),
            const Text(
              'Our story began with a vision to create meaningful impact, driven by compassion and dedication. '
              'Through focused efforts and collaboration, we have transformed communities and provided hope to those in need. '
              'Our programs address challenges ranging from poverty alleviation to health care and education.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'What is Sadqah Zakaat?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: "Cormorant",
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Sadqah and Zakaat are forms of charitable giving in Islam that are used to support the less fortunate. '
              'They are essential components of the Islamic faith, providing a way for individuals to contribute to the welfare of society.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'CEO and Founder of Wadduha Welfare Organization',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: "Cormorant",
              ),
            ),
            const SizedBox(height: 8.0),
            const SectionText('Zuha Rashid'),
            const SizedBox(height: 8.0),
            Center(
              child: Image.asset(
                'Assests/images/Aboutus/zuha.png', // Add the path to your local image
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            const SectionText(
              'As the CEO and founder of Wadduha Welfare Organization, Zuha Rashid has been instrumental in leading the '
              'organization to new heights. Through her vision, she has empowered numerous women and children, providing them '
              'with the resources and support they need to thrive.',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Program Director & Founder of Sadqahzakaat.com',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: "Cormorant",
              ),
            ),
            const SizedBox(height: 8.0),
            const SectionText('Amir Muhammad Azeem'),
            const SizedBox(height: 8.0),
            Center(
              child: Image.asset(
                'Assests/images/Aboutus/Amir.png', // Add the path to your local image
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            const SectionText(
              'Amir Muhammad Azeem, the founder of Sadqahzakaat.com, has been a driving force behind the platform\'s success. '
              'His dedication to providing an easy-to-use platform for Zakaat donations has transformed the way people contribute to charity.',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Communication Director',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: "Cormorant",
              ),
            ),
            const SizedBox(height: 8.0),
            const SectionText('Nauman Anjum'),
            const SizedBox(height: 8.0),
            Center(
              child: Image.asset(
                'Assests/images/Aboutus/Nauman.png', // Add the path to your local image
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            const SectionText(
              'Nauman Anjum, the Communication Director, has been instrumental in shaping the communication strategies of the '
              'organization, ensuring that the message of charity reaches the masses effectively.',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;

  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16.0),
      textAlign: TextAlign.justify,
    );
  }
}

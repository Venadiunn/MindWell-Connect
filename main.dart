import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'dart:collection'; // For SplayTreeSet to get sorted unique categories
import 'dart:async'; // Required for Future and Timer related functions
import 'package:collection/collection.dart'; // For firstWhereOrNull
import 'screens/lotus_companion_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/chat_provider.dart';
import 'providers/session_provider.dart';

/// Local, bundled resource data.
/// Fetched from https://resources.findthelightfoundation.org/portal/resources
final List<Map<String, dynamic>> localResources = <Map<String, dynamic>>[
  {
    "RID": "FLTF_001",
    "title": "988 Suicide & Crisis Lifeline",
    "description": "The 988 Suicide & Crisis Lifeline is a national network of local crisis centers that provides free and confidential emotional support to people in suicidal crisis or emotional distress 24 hours a day, 7 days a week in the U.S. and Canada. Simply call or text 988, or chat at 988lifeline.org/chat.",
    "category": "Crisis Hotline",
    "tags": "suicide, crisis, hotline, text, chat, mental health, emotional support, 24/7",
    "filter": "Phone, Chat",
    "linkTitle": "Call or Text 988",
    "linkURL": "tel:988",
    "religious": false
  },
  {
    "RID": "FLTF_002",
    "title": "Crisis Text Line",
    "description": "Crisis Text Line is a free, 24/7, confidential text message service for people in crisis. Text HOME to 741741 from anywhere in the US, anytime, about any type of crisis. A trained crisis counselor receives the text and responds, all from a secure online platform. The goal is to help people in crisis move from a hot moment to a cool calm.",
    "category": "Crisis Text Support",
    "tags": "crisis, text, 24/7, confidential, support, mental health",
    "filter": "Chat",
    "linkTitle": "Text HOME to 741741",
    "linkURL": "sms:741741",
    "religious": false
  },
  {
    "RID": "FLTF_003",
    "title": "The Trevor Project",
    "description": "The Trevor Project is the leading national organization providing crisis intervention and suicide prevention services to lesbian, gay, bisexual, transgender, queer & questioning (LGBTQ) young people under 25. Services include TrevorLifeline, TrevorText, and TrevorChat.",
    "category": "LGBTQ+ Youth Crisis Support",
    "tags": "LGBTQ, youth, crisis, suicide prevention, lifeline, text, chat",
    "filter": "Phone, Chat",
    "linkTitle": "Visit The Trevor Project",
    "linkURL": "https://www.thetrevorproject.org/",
    "religious": false
  },
  {
    "RID": "FLTF_004",
    "title": "SAMHSA National Helpline",
    "description": "SAMHSA’s National Helpline is a free, confidential, 24/7, 365-day-a-year treatment referral and information service (in English and Spanish) for individuals and families facing mental and/or substance use disorders. This service provides referrals to local treatment facilities, support groups, and community-based organizations. Call 1-800-662-HELP (4357) or visit their website.",
    "category": "Mental Health/Substance-Use Referral Line",
    "tags": "SAMHSA, helpline, referral, mental health, substance use, treatment, 24/7, Spanish",
    "filter": "Phone, Information/Education",
    "linkTitle": "Call 1-800-662-HELP (4357)",
    "linkURL": "tel:18006624357",
    "religious": false
  },
  {
    "RID": "FLTF_005",
    "title": "NAMI (National Alliance on Mental Illness)",
    "description": "NAMI is the nation's largest grassroots mental health organization dedicated to building better lives for the millions of Americans affected by mental illness. They provide education, advocacy, and support. Visit their website for resources, local programs, and information.",
    "category": "Information/Education",
    "tags": "NAMI, advocacy, mental illness, support, education, resources, community",
    "filter": "Information/Education",
    "linkTitle": "Visit NAMI Website",
    "linkURL": "https://www.nami.org/",
    "religious": false
  },
  {
    "RID": "FLTF_006",
    "title": "National Eating Disorders Association (NEDA)",
    "description": "NEDA supports individuals and families affected by eating disorders. Their helpline offers support, resources, and treatment options. They also provide prevention, education, and advocacy efforts. Call or text (800) 931-2237 or chat online.",
    "category": "Eating Disorders Support",
    "tags": "eating disorders, NEDA, helpline, support, treatment, education, advocacy",
    "filter": "Phone, Chat, Information/Education",
    "linkTitle": "Visit NEDA Website",
    "linkURL": "https://www.nationaleatingdisorders.org/",
    "religious": false
  },
  {
    "RID": "FLTF_007",
    "title": "RAINN (Rape, Abuse & Incest National Network)",
    "description": "RAINN is the largest anti-sexual violence organization in the U.S. and operates the National Sexual Assault Hotline. They carry out programs to prevent sexual violence, help survivors, and ensure that perpetrators are brought to justice. Call 1-800-656-HOPE or chat online.",
    "category": "Sexual Assault Support",
    "tags": "sexual assault, rape, abuse, incest, RAINN, hotline, support, prevention",
    "filter": "Phone, Chat",
    "linkTitle": "Call 1-800-656-HOPE",
    "linkURL": "tel:18006564673",
    "religious": false
  },
  {
    "RID": "FLTF_008",
    "title": "National Domestic Violence Hotline",
    "description": "The National Domestic Violence Hotline provides essential tools and support to help survivors of domestic violence so they can live their lives free of abuse. Confidential and free, available 24/7. Call 1-800-799-SAFE (7233) or chat online.",
    "category": "Crisis Hotline",
    "tags": "domestic violence, abuse, hotline, confidential, 24/7, safety planning",
    "filter": "Phone, Chat",
    "linkTitle": "Call 1-800-799-SAFE",
    "linkURL": "tel:18007997233",
    "religious": false
  },
  {
    "RID": "FLTF_009",
    "title": "Loveisrespect National Teen Dating Violence Hotline",
    "description": "Loveisrespect offers a safe space to talk about dating violence, get unbiased information, and receive support. Confidential and free, available 24/7 via phone, text, or chat. Call 1-866-331-9474, text LOVEIS to 22522, or chat online.",
    "category": "Teen Dating Violence Hotline",
    "tags": "dating violence, teen, abuse, hotline, text, chat, healthy relationships",
    "filter": "Phone, Chat",
    "linkTitle": "Call 1-866-331-9474",
    "linkURL": "tel:18663319474",
    "religious": false
  },
  {
    "RID": "FLTF_010",
    "title": "Childhelp National Child Abuse Hotline",
    "description": "The Childhelp National Child Abuse Hotline is dedicated to the prevention of child abuse. Serving the U.S. and Canada, the hotline is staffed 24/7 with professional crisis counselors who can provide assistance in over 170 languages. Call or text 1-800-4-A-CHILD (1-800-422-4453).",
    "category": "Child Abuse Crisis Hotline",
    "tags": "child abuse, child neglect, hotline, crisis, prevention, 24/7, support",
    "filter": "Phone, Chat",
    "linkTitle": "Call or Text 1-800-4-A-CHILD",
    "linkURL": "tel:18004224453",
    "religious": false
  },
  {
    "RID": "FLTF_011",
    "title": "National Runaway Safeline",
    "description": "The National Runaway Safeline (NRS) provides a confidential, 24/7 communication system for runaway and homeless youth. They offer crisis intervention, information, and referrals. Call 1-800-RUNAWAY (1-800-786-2929), text 66008, or chat online.",
    "category": "Runaway/Youth Support",
    "tags": "runaway, homeless youth, youth support, crisis, hotline, text, chat",
    "filter": "Phone, Chat",
    "linkTitle": "Call 1-800-RUNAWAY",
    "linkURL": "tel:18007862929",
    "religious": false
  },
  {
    "RID": "FLTF_012",
    "title": "The Jed Foundation (JED)",
    "description": "JED is a nonprofit that protects emotional health and prevents suicide for teens and young adults. They provide resources, programs for high schools and colleges, and tips for parents and students. Visit their website for comprehensive information.",
    "category": "Youth Mental Health Advocacy",
    "tags": "youth, young adult, suicide prevention, emotional health, mental health, education, advocacy",
    "filter": "Information/Education",
    "linkTitle": "Visit JED Website",
    "linkURL": "https://www.jedfoundation.org/",
    "religious": false
  },
  {
    "RID": "FLTF_013",
    "title": "ULifeline",
    "description": "ULifeline is an anonymous, confidential, online resource center, where college students can go for information about mental health and suicide prevention. It is an initiative of The Jed Foundation. Find help and resources for yourself or a friend.",
    "category": "Youth Mental Health Advocacy",
    "tags": "college students, mental health, suicide prevention, young adult, online resource",
    "filter": "Information/Education",
    "linkTitle": "Visit ULifeline Website",
    "linkURL": "https://www.ulifeline.org/",
    "religious": false
  },
  {
    "RID": "FLTF_014",
    "title": "Mental Health America (MHA)",
    "description": "Mental Health America is the nation's leading community-based nonprofit dedicated to addressing the needs of those living with mental illness and to promoting the overall mental health of all. They offer screening tools, resources, and advocacy. Visit their website for more information.",
    "category": "Information/Education",
    "tags": "mental health, mental illness, advocacy, screening, resources, community",
    "filter": "Information/Education",
    "linkTitle": "Visit MHA Website",
    "linkURL": "https://www.mhanational.org/",
    "religious": false
  },
  {
    "RID": "FLTF_015",
    "title": "Anxiety & Depression Association of America (ADAA)",
    "description": "ADAA is an international nonprofit organization dedicated to the prevention, treatment, and cure of anxiety, depression, OCD, PTSD, and co-occurring disorders. They provide a comprehensive list of resources, including therapist finders and support groups. Visit their website.",
    "category": "Information/Education",
    "tags": "anxiety, depression, OCD, PTSD, support, treatment, research, resources, therapist finder",
    "filter": "Information/Education, Locator",
    "linkTitle": "Visit ADAA Website",
    "linkURL": "https://adaa.org/",
    "religious": false
  },
  {
    "RID": "FLTF_016",
    "title": "Depression and Bipolar Support Alliance (DBSA)",
    "description": "DBSA provides hope, help, support, and education to improve the lives of people who have mood disorders. They offer peer-led support groups for depression and bipolar disorder. Visit their website for resources and local chapter information.",
    "category": "Peer Support Hotline",
    "tags": "depression, bipolar disorder, mood disorders, peer support, support groups, education",
    "filter": "Peer Support, Information/Education",
    "linkTitle": "Visit DBSA Website",
    "linkURL": "https://www.dbsalliance.org/",
    "religious": false
  },
  {
    "RID": "FLTF_017",
    "title": "National Institute of Mental Health (NIMH)",
    "description": "NIMH is the lead federal agency for research on mental disorders. Their mission is to transform the understanding and treatment of mental illnesses through basic and clinical research, paving the way for prevention, recovery, and cures. Provides extensive information and research findings.",
    "category": "Government Resource",
    "tags": "NIMH, research, mental disorders, mental illness, prevention, treatment, federal",
    "filter": "Information/Education",
    "linkTitle": "Visit NIMH Website",
    "linkURL": "https://www.nimh.nih.gov/",
    "religious": false
  },
  {
    "RID": "FLTF_018",
    "title": "CDC - Mental Health",
    "description": "The Centers for Disease Control and Prevention (CDC) offers information and resources on mental health topics, including data, statistics, and prevention strategies. Visit their website for public health information.",
    "category": "Government Resource",
    "tags": "CDC, public health, mental health, data, statistics, prevention",
    "filter": "Information/Education",
    "linkTitle": "Visit CDC Mental Health",
    "linkURL": "https://www.cdc.gov/mentalhealth/",
    "religious": false
  },
  {
    "RID": "FLTF_019",
    "title": "National Center for PTSD",
    "description": "The National Center for PTSD is dedicated to research and education on trauma and PTSD. They offer evidence-based resources for veterans and the public, including self-help tools and information on treatment options. Visit their website for resources and tools.",
    "category": "Information/Education",
    "tags": "PTSD, trauma, veterans, self-help, treatment, research, education",
    "filter": "Information/Education",
    "linkTitle": "Visit PTSD Center",
    "linkURL": "https://www.ptsd.va.gov/",
    "religious": false
  },
  {
    "RID": "FLTF_020",
    "title": "StopBullying.gov",
    "description": "A federal government website managed by the U.S. Department of Health & Human Services, providing information about what bullying is, what cyberbullying is, who is at risk, and how you can prevent and respond to bullying. Includes resources for youth, parents, educators, and communities.",
    "category": "Bullying Prevention (Government)",
    "tags": "bullying, cyberbullying, prevention, youth, parents, educators, government",
    "filter": "Information/Education",
    "linkTitle": "Visit StopBullying.gov",
    "linkURL": "https://www.stopbullying.gov/",
    "religious": false
  },
  {
    "RID": "FLTF_021",
    "title": "GriefShare",
    "description": "GriefShare is a friendly, caring group of people who will walk alongside you through one of life’s most difficult experiences. You don’t have to go through the grieving process alone. They offer support groups led by people who understand what you are experiencing. Available through local churches.",
    "category": "Grief Support",
    "tags": "grief, loss, support group, bereavement, church-based",
    "filter": "Peer Support, Religious",
    "linkTitle": "Find a GriefShare Group",
    "linkURL": "https://www.griefshare.org/",
    "religious": true
  },
  {
    "RID": "FLTF_022",
    "title": "Online Therapy through City Programs",
    "description": "Some cities offer free or low-cost online therapy services to their residents. These programs often provide access to licensed therapists via video calls or messaging platforms. Check your local city/county health department website for availability and eligibility.",
    "category": "Online Therapy (City Program)",
    "tags": "online therapy, telehealth, virtual therapy, city program, low-cost, free, mental health services",
    "filter": "Telehealth, Services",
    "linkTitle": "Search Local City Health Dept.",
    "linkURL": "https://www.google.com/search?q=online+therapy+city+program",
    "religious": false
  },
  {
    "RID": "FLTF_023",
    "title": "Psychology Today - Find a Therapist",
    "description": "Psychology Today's online directory allows you to find a therapist, psychiatrist, or treatment center near you. You can filter by insurance, specialty, gender, and more. A widely used resource for finding mental health professionals.",
    "category": "Treatment Locator",
    "tags": "therapist, psychiatrist, treatment center, mental health professional, directory, search",
    "filter": "Locator",
    "linkTitle": "Find a Therapist",
    "linkURL": "https://www.psychologytoday.com/us/therapists",
    "religious": false
  },
  {
    "RID": "FLTF_024",
    "title": "Postpartum Support International (PSI)",
    "description": "PSI offers support to women and families coping with pregnancy and postpartum mood and anxiety disorders (PMADs). They provide a helpline, online support groups, and a directory of local resources. Call or text 1-800-944-4773 (4PSI).",
    "category": "Maternal Mental Health Support",
    "tags": "postpartum, pregnancy, maternal mental health, depression, anxiety, PMADs, helpline, support groups",
    "filter": "Phone, Peer Support, Information/Education",
    "linkTitle": "Visit PSI Website",
    "linkURL": "https://www.postpartum.net/",
    "religious": false
  },
  {
    "RID": "FLTF_025",
    "title": "National Queer and Trans Therapists of Color Network (NQTTCN)",
    "description": "NQTTCN is a healing justice organization committed to transforming mental health for queer and trans people of color (QTPoC). They provide a directory of QTPoC mental health practitioners and promote the well-being of their communities. Visit their website to find a therapist.",
    "category": "LGBTQ+ Youth Crisis Support",
    "tags": "LGBTQ, queer, transgender, people of color, QTPoC, therapist directory, mental health, healing justice",
    "filter": "Locator, Peer Support",
    "linkTitle": "Find a Therapist (NQTTCN)",
    "linkURL": "https://nqttcn.com/directory/",
    "religious": false
  },
  {
    "RID": "FLTF_026",
    "title": "Therapy for Black Girls",
    "description": "Therapy for Black Girls is an online space dedicated to encouraging the mental wellness of Black women and girls. They provide a directory of mental health professionals and an online community. Visit their website to find a therapist.",
    "category": "Peer Support Hotline",
    "tags": "Black women, Black girls, mental wellness, therapist directory, community, support",
    "filter": "Locator, Peer Support",
    "linkTitle": "Find a Therapist (TBG)",
    "linkURL": "https://therapyforblackgirls.com/",
    "religious": false
  },
  {
    "RID": "FLTF_027",
    "title": "Latinx Therapy",
    "description": "Latinx Therapy strives to break the stigma of mental health in the Latinx community. They offer a directory of Latinx therapists, a podcast, and resources. Visit their website to find a therapist and learn more.",
    "category": "Mental Health Info (Spanish)",
    "tags": "Latinx, Hispanic, mental health, therapist directory, podcast, resources, stigma",
    "filter": "Locator, Information/Education",
    "linkTitle": "Find a Therapist (Latinx Therapy)",
    "linkURL": "https://latinxtherapy.com/",
    "religious": false
  },
  {
    "RID": "FLTF_028",
    "title": "Asian Mental Health Collective",
    "description": "The Asian Mental Health Collective aims to normalize and de-stigmatize mental health within Asian communities worldwide. They provide a directory of Asian therapists, resources, and community events. Visit their website.",
    "category": "Peer Support Hotline",
    "tags": "Asian, AAPI, mental health, stigma, therapist directory, resources, community",
    "filter": "Locator, Peer Support",
    "linkTitle": "Find a Therapist (AMHC)",
    "linkURL": "https://www.asianmentalhealthcollective.org/",
    "religious": false
  },
  {
    "RID": "FLTF_029",
    "title": "The Loveland Foundation",
    "description": "The Loveland Foundation provides financial assistance to Black women and girls seeking therapy. They also offer resources and foster community for healing. Visit their website to learn more and apply for assistance.",
    "category": "Community Resource Hotline",
    "tags": "Black women, Black girls, therapy, financial assistance, healing, community",
    "filter": "Services",
    "linkTitle": "Visit Loveland Foundation",
    "linkURL": "https://thelovelandfoundation.org/",
    "religious": false
  },
  {
    "RID": "FLTF_030",
    "title": "Online Cognitive Behavioral Therapy (CBT) Programs",
    "description": "Several online platforms offer structured CBT programs that you can follow at your own pace. These often include modules, exercises, and sometimes even access to a therapist. Examples include MoodGYM, e-Couch, and paid services like BetterHelp or Talkspace (though these are not free).",
    "category": "Online Therapy (City Program)",
    "tags": "CBT, online therapy, self-help, cognitive behavioral therapy, anxiety, depression",
    "filter": "Telehealth, Information/Education",
    "linkTitle": "Search Online CBT Programs",
    "linkURL": "https://www.google.com/search?q=online+cbt+programs",
    "religious": false
  },
  {
    "RID": "FLTF_031",
    "title": "The Anxiety & Phobia Workbook",
    "description": "This classic self-help workbook provides step-by-step guidance for overcoming anxiety, panic attacks, phobias, and obsessive-compulsive disorder. It includes practical exercises and tools based on cognitive behavioral therapy (CBT).",
    "category": "Information/Education",
    "tags": "anxiety, phobia, workbook, self-help, CBT, panic attack, OCD",
    "filter": "LearnAbout",
    "linkTitle": "Find on Amazon",
    "linkURL": "https://www.amazon.com/Anxiety-Phobia-Workbook-Edmund-Bourne/dp/1626252157",
    "religious": false
  },
  {
    "RID": "FLTF_032",
    "title": "Mindfulness-Based Stress Reduction (MBSR) Programs",
    "description": "MBSR programs teach mindfulness meditation and gentle yoga to help individuals cope with stress, anxiety, pain, and illness. These are often offered in-person at community centers or online. Search for local or online MBSR programs.",
    "category": "Information/Education",
    "tags": "mindfulness, MBSR, stress reduction, meditation, yoga, anxiety, pain, illness",
    "filter": "LearnAbout",
    "linkTitle": "Search MBSR Programs",
    "linkURL": "https://www.google.com/search?q=mindfulness+based+stress+reduction+programs",
    "religious": false
  },
  {
    "RID": "FLTF_033",
    "title": "DBT Skills Training Manual",
    "description": "Dialectical Behavior Therapy (DBT) is a type of cognitive-behavioral therapy that teaches skills to manage emotions, improve relationships, and cope with distress. This manual provides exercises and handouts for learning DBT skills. Often used in therapy but can also be a self-help tool.",
    "category": "Information/Education",
    "tags": "DBT, dialectical behavior therapy, emotional regulation, distress tolerance, interpersonal effectiveness, mindfulness, self-help",
    "filter": "LearnAbout",
    "linkTitle": "Find on Amazon",
    "linkURL": "https://www.amazon.com/DBT®-Skills-Training-Handouts-Worksheets/dp/1572307811",
    "religious": false
  },
  {
    "RID": "FLTF_034",
    "title": "Calm App",
    "description": "Calm is a popular app for meditation and sleep. It offers guided meditations, sleep stories, breathing programs, and relaxing music to help reduce stress and improve focus. Subscription required for full access.",
    "category": "Information/Education",
    "tags": "meditation, sleep, mindfulness, breathing, relaxation, app",
    "filter": "App",
    "linkTitle": "Download Calm App",
    "linkURL": "https://www.calm.com/",
    "religious": false
  },
  {
    "RID": "FLTF_035",
    "title": "Headspace App",
    "description": "Headspace is another popular meditation and mindfulness app. It teaches you how to meditate with guided exercises and offers tools for stress, sleep, focus, and movement. Subscription required for full access.",
    "category": "Information/Education",
    "tags": "meditation, mindfulness, stress, sleep, focus, app",
    "filter": "App",
    "linkTitle": "Download Headspace App",
    "linkURL": "https://www.headspace.com/",
    "religious": false
  },
  {
    "RID": "FLTF_036",
    "title": "BetterHelp",
    "description": "BetterHelp is an online portal that provides convenient and affordable access to licensed therapists. Connect with a therapist via video, phone, or chat. Subscription-based service.",
    "category": "Online Therapy (City Program)",
    "tags": "online therapy, telehealth, therapy, licensed therapist, video, phone, chat",
    "filter": "Telehealth, Services",
    "linkTitle": "Visit BetterHelp",
    "linkURL": "https://www.betterhelp.com/",
    "religious": false
  },
  {
    "RID": "FLTF_037",
    "title": "Talkspace",
    "description": "Talkspace offers online therapy from licensed therapists. You can send text, audio, and video messages to your therapist and also schedule live sessions. Subscription-based service.",
    "category": "Online Therapy (City Program)",
    "tags": "online therapy, telehealth, therapy, licensed therapist, text, audio, video, live sessions",
    "filter": "Telehealth, Services",
    "linkTitle": "Visit Talkspace",
    "linkURL": "https://www.talkspace.com/",
    "religious": false
  },
  {
    "RID": "FLTF_038",
    "title": "Gratitude Journaling Prompts",
    "description": "Practicing gratitude can improve mental well-being. This resource provides prompts and ideas for starting a gratitude journal to help you focus on positive aspects of your life.",
    "category": "Information/Education",
    "tags": "gratitude, journaling, positive psychology, well-being, mental health",
    "filter": "LearnAbout",
    "linkTitle": "Explore Prompts",
    "linkURL": "https://www.healthline.com/health/mental-health/gratitude-journal-prompts",
    "religious": false
  },
  {
    "RID": "FLTF_039",
    "title": "Physical Activity for Mental Health",
    "description": "Regular physical activity is a powerful tool for boosting mood, reducing stress, and improving overall mental health. This resource outlines the benefits and provides tips for incorporating exercise into your routine.",
    "category": "Information/Education",
    "tags": "physical activity, exercise, mental health, mood, stress reduction, well-being",
    "filter": "LearnAbout",
    "linkTitle": "Learn More",
    "linkURL": "https://www.nimh.nih.gov/health/topics/physical-health-and-mental-health",
    "religious": false
  },
  {
    "RID": "FLTF_040",
    "title": "The Mighty",
    "description": "The Mighty is a digital health community created to empower and connect people facing health challenges. They feature real stories, provide support, and share resources on various mental health conditions and chronic illnesses.",
    "category": "Community Resource Hotline",
    "tags": "community, support, stories, mental health, chronic illness, digital health",
    "filter": "Information/Education, Peer Support",
    "linkTitle": "Visit The Mighty",
    "linkURL": "https://themighty.com/",
    "religious": false
  },
  {
    "RID": "FLTF_041",
    "title": "Crisis Text Line (Spanish)",
    "description": "Crisis Text Line provides free, 24/7, confidential text message service for people in crisis, now also available in Spanish. Text HOLA to 741741 from anywhere in the US.",
    "category": "Crisis Text Support",
    "tags": "crisis, text, 24/7, confidential, support, mental health, Spanish",
    "filter": "Chat, Spanish",
    "linkTitle": "Text HOLA to 741741",
    "linkURL": "sms:741741",
    "religious": false
  },
  {
    "RID": "FLTF_042",
    "title": "Trans Lifeline",
    "description": "Trans Lifeline is a trans-led organization that connects trans people to the community, resources, and support they need to survive and thrive. Call for peer support: 877-565-8860.",
    "category": "Transgender Support Hotline",
    "tags": "transgender, crisis, peer support, hotline, LGBTQ",
    "filter": "Phone, Peer Support",
    "linkTitle": "Call 877-565-8860",
    "linkURL": "tel:18775658860",
    "religious": false
  },
  {
    "RID": "FLTF_043",
    "title": "StrongHearts Native Helpline",
    "description": "The StrongHearts Native Helpline is a safe, confidential, and anonymous national helpline for Native Americans impacted by domestic violence and sexual assault. Call or text 1-844-7NATIVE (762-8483) or chat online.",
    "category": "Crisis Hotline",
    "tags": "Native American, Indigenous, domestic violence, sexual assault, hotline, text, chat",
    "filter": "Phone, Chat",
    "linkTitle": "Call or Text 1-844-7NATIVE",
    "linkURL": "tel:18447628483",
    "religious": false
  },
  {
    "RID": "FLTF_044",
    "title": "Veterans Crisis Line",
    "description": "The Veterans Crisis Line is a free, confidential resource for Veterans of all ages and circumstances. Veterans and their loved ones can call 988 and press 1, text 838255, or chat online at VeteransCrisisLine.net/Chat.",
    "category": "Statewide Crisis Hotline",
    "tags": "veterans, crisis, suicide prevention, hotline, text, chat, military",
    "filter": "Phone, Chat",
    "linkTitle": "Call 988, Press 1",
    "linkURL": "tel:988;phone-context=+1;ext=1",
    "religious": false
  },
  {
    "RID": "FLTF_045",
    "title": "The Trevor Project (Spanish Resources)",
    "description": "The Trevor Project also offers resources and crisis support for LGBTQ young people in Spanish. Visit their website for more information on Spanish-language services.",
    "category": "LGBTQ+ Youth Crisis Support",
    "tags": "LGBTQ, youth, crisis, suicide prevention, Spanish, resources",
    "filter": "Information/Education, Spanish",
    "linkTitle": "Visit Trevor Project Spanish",
    "linkURL": "https://www.thetrevorproject.org/es/",
    "religious": false
  },
  {
    "RID": "FLTF_046",
    "title": "Substance Abuse and Mental Health Services Administration (SAMHSA) - Disaster Distress Helpline",
    "description": "The Disaster Distress Helpline, 1-800-985-5990, is a 24/7, 365-day-a-year, national hotline dedicated to providing immediate crisis counseling for people experiencing emotional distress related to natural or human-caused disasters. This toll-free, multilingual, and confidential crisis support service is available to all residents in the U.S. and its territories.",
    "category": "State Crisis Hotline",
    "tags": "disaster, crisis, helpline, emotional distress, 24/7, multilingual, confidential",
    "filter": "Phone",
    "linkTitle": "Call 1-800-985-5990",
    "linkURL": "tel:18009855990",
    "religious": false
  },
  {
    "RID": "FLTF_047",
    "title": "National Federation of Families for Children's Mental Health",
    "description": "The National Federation of Families for Children's Mental Health is a national family-run organization linking more than 120 chapters and state organizations focused on the issues of children and youth with emotional, behavioral, or mental health challenges. They provide advocacy, education, and support. Visit their website for resources and local chapters.",
    "category": "Child/Family Crisis Hotline",
    "tags": "children, youth, families, mental health, emotional challenges, behavioral challenges, advocacy, education, support",
    "filter": "Information/Education, Peer Support",
    "linkTitle": "Visit National Federation of Families",
    "linkURL": "https://www.ffcmh.org/",
    "religious": false
  }
];

final List<Map<String, dynamic>> additionalResources = <Map<String, dynamic>>[
  {
    "linkTitle": "1(877) 726-4727",
    "category": "General",
    "tags": "undefined",
    "RID": "00001",
    "linkURL": "tel:18777264727",
    "filter": "Phone",
    "religious": false,
    "title": "SAMHSA Treatment Referral",
    "description": "Helpline: Treatment referral and information service (English/Spanish) for those facing mental and/or substance use disorders.\n(24/7)"
  },
  {
    "linkURL": "tel:18005333231",
    "category": "PainIllness",
    "title": "American Chronic Pain Association",
    "linkTitle": "1(800) 533-3231",
    "description": "Helpline: Provides peer support, educational information, and treatment referral for individuals and families with chronic pain",
    "filter": "Phone",
    "RID": "00005",
    "tags": "undefined"
  },
  {
    "linkURL": "https://www.cdc.gov/lgbthealth/youth.htm",
    "filter": "LearnAbout",
    "tags": "lesbian gay bisexual transgender",
    "category": "LGBTQI",
    "description": "Website: Provides information related to youth mental and physical health in LGBTQI+ communities",
    "RID": "00006",
    "linkTitle": "CDC LGBT+",
    "title": "LGBT+ Youth Mental/Physical Health"
  },
  {
    "RID": "00007",
    "description": "Website: Provides support and information on LGBTQI+ mental health to raise awareness and improve mental health",
    "tags": "undefined",
    "filter": "LearnAbout",
    "linkURL": "https://www.nami.org/Your-Journey/Identity-and-Cultural-Dimensions/LGBTQI",
    "title": "NAMI LGBTQI",
    "linkTitle": "NAMI LGBTQI",
    "category": "LGBTQI"
  },
  {
    "filter": "LearnAbout",
    "tags": "undefined",
    "linkURL": "http://www.glbtnationalhelpcenter.org/",
    "RID": "00008",
    "linkTitle": "LGBT National Help Center",
    "title": "LGBT National Help Center",
    "category": "LGBTQI",
    "description": "Website: Provides National confidential peer support, direct information, local resources, and more for LGBTQI+ communities"
  },
  {
    "tags": "undefined",
    "filter": "LearnAbout",
    "linkURL": "https://www.apa.org/topics/sexual-orientation",
    "RID": "00010",
    "linkTitle": "APA Sexual Orientation",
    "description": "Website: Provides psychological science information and resources on Gender Identity and Sexual Orientation",
    "category": "LGBTQI",
    "title": "American Psychological Association"
  },
  {
    "tags": "undefined",
    "RID": "00011",
    "linkURL": "https://www.mentalhealth.va.gov/",
    "title": "U.S. Department of Veterans Affairs",
    "linkTitle": " VA Mental Health",
    "description": "Website: Provides mental health resources, information, treatment options, and more for veterans and the general public",
    "filter": "LearnAbout",
    "category": "Military"
  },
  {
    "linkURL": "https://www.nami.org/Your-Journey/Veterans-Active-Duty",
    "RID": "00012",
    "tags": "undefined",
    "title": "National Alliance on Mental Illness Veterans",
    "linkTitle": "NAMI Veterans and Active Duty",
    "description": "Website: Provide information, support, and education for veterans, service members, and families affected by mental illness",
    "filter": "LearnAbout",
    "category": "Military",
    "religious": false
  },
  {
    "RID": "00013",
    "religious": false,
    "description": "Website: Confidential and anonymous mental health screening that provides results, recommendations, and key resources ",
    "linkTitle": "MindWise Innovations",
    "linkURL": "https://screening.mentalhealthscreening.org/Military_NDSD",
    "filter": "Services",
    "tags": "undefined",
    "category": "Military",
    "title": "Military and Family Screenings"
  },
  {
    "description": "Website: Informs policy, programs, practices, and provides information related to the mental health of racial and ethnic minorities ",
    "linkURL": "https://www.minorityhealth.hhs.gov/",
    "tags": "undefined",
    "category": "BIPOC",
    "filter": "LearnAbout",
    "RID": "00014",
    "title": "Office of Minority Health"
  },
  {
    "description": "Website: Informs policy, education, and provides innovative programs to help improve the mental health of girls and women ",
    "filter": "LearnAbout",
    "tags": "undefined",
    "linkURL": "https://www.womenshealth.gov/mental-health/mental-health-resources",
    "category": "Women",
    "RID": "00015",
    "title": "Office on Women's Health: Mental Health",
    "linkTitle": "Office of Women's Health"
  },
  {
    "category": "Women",
    "linkTitle": "NIMH Women",
    "tags": "undefined",
    "description": "Website: Biomedical federal agency for information and treatment of mental illnesses through basic and clinical research",
    "RID": "00016",
    "linkURL": "https://www.nimh.nih.gov/health/topics/women-and-mental-health/index.shtml",
    "filter": "LearnAbout",
    "title": "National Institute of Mental Health"
  },
  {
    "tags": "undefined",
    "category": "YouthYoungAdult",
    "linkURL": "https://opa.hhs.gov/adolescent-health?adolescent-development/mental-health/index.html",
    "RID": "00018",
    "title": "HHS Office of Population Affairs",
    "linkTitle": "HHS Adolescent Health",
    "description": "Website: Highlighting key topics, health treatment/service information and featured resources on Adolescent Health",
    "filter": "LearnAbout"
  },
  {
    "linkTitle": "Jed Foundation",
    "RID": "00019",
    "tags": "undefined",
    "title": "The Jed Foundation",
    "description": "Website: Raises awareness to protect mental health. Prevent harm by providing education, training, and tools for teens",
    "linkURL": "https://www.jedfoundation.org/",
    "category": "YouthYoungAdult",
    "filter": "LearnAbout"
  },
  {
    "tags": "undefined",
    "description": "Website: Raises mental health awareness through educational resources, professional practice, and scientific research",
    "religious": false,
    "title": "Anxiety & Depression Association of America",
    "linkURL": "https://adaa.org/understanding-anxiety",
    "RID": "00020",
    "category": "Anxiety",
    "filter": "LearnAbout",
    "linkTitle": "ADAA"
  },
  {
    "category": "Anxiety",
    "linkTitle": "Freedom From Fear",
    "title": "Freedom from Fear",
    "RID": "00021",
    "tags": "undefined",
    "description": "Website: Mental health advocacy organization that provides resources and treatment for individuals suffering with forms of anxiety",
    "linkURL": "http://www.freedomfromfear.org/",
    "religious": false,
    "filter": "LearnAbout"
  },
  {
    "category": "Autism",
    "filter": "LearnAbout",
    "linkTitle": "Autism Now",
    "RID": "00022",
    "linkURL": "https://autismnow.org/",
    "tags": "undefined",
    "description": "Website: Provides information on community-based solutions for individuals with autism, and other developmental disabilities",
    "title": "The Arc's Autism Now"
  },
  {
    "description": "Website: Provides advocacy, education, support and public awareness for individuals and families affected by autism",
    "filter": "LearnAbout",
    "linkTitle": "NAMI Autism",
    "title": "National Alliance on Mental Illness",
    "RID": "00023",
    "linkURL": "https://www.nami.org/Learn-More/Mental-Health-Conditions/Related-Conditions/Autism",
    "category": "Autism",
    "tags": "undefined"
  },
  {
    "RID": "00024",
    "filter": "LearnAbout",
    "description": "Website: Information and resources for people who are affected by bipolar disorder and/or depression",
    "tags": "undefined",
    "linkTitle": "DBSA",
    "category": "Bipolar",
    "title": "Depression and Bipolar Support Alliance",
    "linkURL": "https://www.dbsalliance.org/"
  },
  {
    "category": "EatingDisorders",
    "filter": "LearnAbout",
    "linkURL": "https://www.nationaleatingdisorders.org/",
    "tags": "undefined",
    "title": "National Eating Disorders Association",
    "RID": "00025",
    "linkTitle": "NEDA",
    "description": "Website: Provides information and resources to those who think they way have an eating disorder and are looking for options"
  },
  {
    "description": "Helpline: Provides caller with help in finding local treatment options for a variety of sexual health categories.\n(24/7)",
    "tags": "undefined",
    "RID": "00027",
    "filter": "Phone",
    "linkURL": "tel:18002307526",
    "title": "Planned Parenthood Treatment Hotline",
    "linkTitle": "1(800) 230-PLAN (7526)",
    "category": "Pregnancy"
  },
  {
    "religious": false,
    "RID": "00028",
    "category": "Abuse",
    "linkURL": "tel:18007997233",
    "linkTitle": "1(800) 799-7233",
    "filter": "Phone",
    "description": "Helpline: Offering support and next steps to people who are currently in, or have been in an abusive relationship.\n(24/7)",
    "tags": "undefined",
    "title": "National Domestic Violence And Abuse"
  },
  {
    "category": "Misc",
    "linkTitle": "1(800) RUNAWAY (786-2929)",
    "tags": "undefined",
    "filter": "Phone",
    "description": "Helpline: Connect with a trusted, compassionate person who will listen and help you create a plan to address your concerns.\n(24/7)",
    "linkURL": "tel:18007862929",
    "title": "National Runaway Hotline",
    "RID": "00029",
    "religious": false
  },
  {
    "linkURL": "tel:18008435678",
    "title": "Hotline for Missing and Exploited Children",
    "category": "Abuse",
    "linkTitle": "1(800) 843-5678",
    "religious": false,
    "description": "Helpline: For runaways and exploited children or those with knowledge of expolitation.\n(24/7)",
    "RID": "00030",
    "filter": "Phone",
    "tags": "undefined"
  },
  {
    "linkTitle": "1(800) I-AM-LOST (426-5678)",
    "category": "Misc",
    "filter": "Phone",
    "linkURL": "tel:18004265678",
    "title": "ChildFind of America",
    "RID": "00031",
    "religious": false,
    "description": "Helpline: Connects callers to our ChildFind staff who search for missing, kidnapped, runaway and abducted children.\n(M-F 8am-4pm CST)",
    "tags": "undefined"
  },
  {
    "title": "Al-Anon for Families of Alcoholics",
    "linkURL": "https://al-anon.org/",
    "filter": "Families",
    "linkTitle": "Al-Anon",
    "RID": "00032",
    "category": "SubstanceAbuse",
    "tags": "undefined",
    "description": "Website: Support for families of alcoholics or people who are worried about someone with a drinking problem."
  },
  {
    "description": "Website: a Fellowship of people who share their experience, strength, and hope with each other to help others recover.",
    "title": "Cocaine Anonymous",
    "linkTitle": "Cocaine Anonymous",
    "linkURL": "https://ca.org/",
    "filter": "LearnAbout",
    "RID": "00034",
    "tags": "undefined",
    "category": "SubstanceAbuse"
  },
  {
    "description": "Website: For relatives and friends concerned about the use of drugs or related behavioral problems.",
    "RID": "00035",
    "title": "Families Anonymous",
    "linkURL": "https://www.familiesanonymous.org/",
    "category": "SubstanceAbuse",
    "tags": "undefined",
    "linkTitle": "Families Anonymous",
    "filter": "LearnAbout"
  },
  {
    "RID": "00038",
    "tags": "undefined",
    "filter": "Phone",
    "description": "Helpline: Providing crisis reources and support for people struggling with self injury\n(hours unknown)",
    "title": "Self Injury Hotline",
    "linkURL": "tel:18003668288",
    "linkTitle": "1(800) DONT-CUT (366-8288)",
    "category": "SelfHarm"
  },
  {
    "tags": "undefined",
    "filter": "Phone",
    "description": "Helpline: crisis counseling for those experiencing emotional distress related to any natural or human-caused disaster.\n(24/7)",
    "linkURL": "tel:18009855990",
    "linkTitle": "1(800) 985-5990",
    "RID": "00039",
    "category": "General",
    "title": "SAMHSA Disaster Distress-Immediate Counseling",
    "religious": false
  },
  {
    "description": "Helpline: Provides referrals to mental health resources and providers in English and Spanish.\n(24/7)",
    "linkTitle": "1(800) 662-4357",
    "category": "BIPOC",
    "linkURL": "tel:18006624357",
    "tags": "undefined",
    "RID": "00040",
    "filter": "Phone",
    "title": "SAMHSA Bi-lingual Referral Line"
  },
  {
    "linkURL": "tel:18883737888",
    "category": "Misc",
    "RID": "00041",
    "filter": "Phone",
    "religious": false,
    "tags": "undefined",
    "description": "Helpline: Providing anti-trafficing help and referrals for those who are victim of human trafficking.\n(24/7)",
    "linkTitle": "1(888) 373-7888",
    "title": "National Human Trafficking Resource Hotline"
  },
  {
    "RID": "00042",
    "tags": "undefined",
    "description": "Chatline: Providing anti-trafficing help and referrals for those who are victim of human trafficking.\n(24/7)",
    "category": "Misc",
    "filter": "Chat",
    "linkURL": "sms:233733",
    "religious": false,
    "title": "National Human Trafficking Resource Chatline",
    "linkTitle": "\"HELP\" to BEFREE (233733)"
  },
  {
    "filter": "Phone",
    "linkTitle": "1(800) 959-TAPS (8277)",
    "category": "GriefLoss",
    "title": "Tragedy Assistance Program for Survivors",
    "description": "Helpline: national organization providing compassionate care for all those grieving the death of a military loved one.\n(24/7)",
    "RID": "00043",
    "tags": "undefined"
  },
  {
    "tags": "undefined",
    "category": "YouthYoungAdult",
    "filter": "Chat",
    "linkURL": "tel:18663319474",
    "linkTitle": "1(866) 331-9474",
    "RID": "00044",
    "description": "Helpline: Offers support, education, and advocacy to teens and young adults with questions or concerns about dating and relationships.\n(24/7)",
    "title": "Love is respect: Teen Dating Abuse Helpline"
  },
  {
    "tags": "undefined",
    "RID": "00045",
    "category": "YouthYoungAdult",
    "linkURL": "sms:22522",
    "title": "Love is respect: Teen Dating Abuse Chatline",
    "filter": "Phone",
    "description": "Chatline: Offers support, education, and advocacy to teens and young adults with questions or concerns about dating and relationships.\n(24/7)",
    "linkTitle": "\"LOVEIS\" to 22522"
  },
  {
    "tags": "undefined",
    "linkURL": "tel:18775658860",
    "title": "Trans Lifeline",
    "description": "Helpline: Peer support and crisis hotline for members of the trans and gender nonconforming community.\n(24/7)",
    "RID": "00046",
    "linkTitle": "1(877) 565-8860",
    "religious": false,
    "filter": "Phone",
    "category": "Transgender"
  },
  {
    "title": "National Safe Haven Alliance",
    "filter": "Phone",
    "tags": "undefined",
    "description": "Helpline: Nurses and social workers ready to answer questions and provide support and options for unexpected pregnancies.\n(24/7)",
    "linkTitle": "1(888) 510-BABY (2229)",
    "category": "Pregnancy",
    "RID": "00047",
    "linkURL": "tel:18885102229"
  },
  {
    "description": "Service: connecting people to free and reduced price counseling services local to them.",
    "RID": "00048",
    "title": "Open Counseling",
    "filter": "Services",
    "linkURL": "https://www.opencounseling.com",
    "linkTitle": "Open Counseling",
    "category": "General"
  },
  {
    "linkURL": "https://www.theprojectheal.org/",
    "description": "Website: providing information and programs to help those struggling with eating disorders.",
    "tags": "undefined",
    "linkTitle": "Project Heal",
    "title": "Project Heal",
    "filter": "LearnAbout",
    "RID": "00049",
    "category": "EatingDisorders"
  },
  {
    "filter": "Phone",
    "linkTitle": "1(800) 931-2237",
    "category": "EatingDisorders",
    "tags": "undefined",
    "title": "NEDA Call line",
    "linkURL": "tel:18009312237",
    "RID": "00050",
    "description": "Helpline: providing support, resources and treatment options for anyone affected by an eating disorder.\n(M-Th 10am-8pm, F 10am-4pm CST)"
  },
  {
    "RID": "00051",
    "category": "EatingDisorders",
    "description": "Chatline: providing support, resources and treatment options for anyone affected by an eating disorder.\n(M-Th 2pm-5pm, F 12pm-4pm CST)",
    "linkTitle": "1(800) 931-2237",
    "title": "NEDA Text Line",
    "tags": "undefined",
    "linkURL": "sms:18009312237",
    "filter": "Chat"
  },
  {
    "title": "Suicide Prevention Lifeline",
    "RID": "00052",
    "linkTitle": "Call or Text 988",
    "filter": "Phone",
    "linkURL": "tel:988",
    "tags": "undefined",
    "category": "General",
    "religious": false,
    "description": "Helpline: Providing free and confidential support for people in distress, prevention and crisis resources for you or your loved ones.\n(24/7)"
  },
  {
    "religious": false,
    "RID": "00053",
    "category": "General",
    "title": "Crisis Text Line",
    "description": "Chatline: Talk to a trained crisis counselor who can help you with a variety of mental health concerns\n(24/7)",
    "linkTitle": "\"HOME\" to 741741",
    "filter": "Phone",
    "linkURL": "sms:741741",
    "tags": "undefined"
  },
  {
    "RID": "00055",
    "linkURL": "tel:18884489777",
    "title": "Project Return Peer Support Network Warmline",
    "filter": "Phone",
    "linkTitle": "1(888) 448-9777 (English)",
    "description": "Helpline: Staff uses lived experiences to support callers experiening hard times.\n(M-F 5pm-2am, Sa-Su 12pm-8pm CST)",
    "tags": "undefined",
    "category": "General"
  },
  {
    "RID": "00056",
    "filter": "Phone",
    "linkURL": "tel:18884489777",
    "category": "General",
    "tags": "undefined",
    "description": "Helpline: Staff uses lived experiences to support callers experiening hard times. (Spanish)\n(M-F 5pm-2am, Sa-Su 12pm-8pm CST)",
    "title": "Project Return Peer Support Network Warmline",
    "linkTitle": "1(888) 448-9777 (Spanish)"
  },
  {
    "title": "Compassionate Ear Warm Line",
    "category": "General",
    "linkTitle": "1(866) 927-6327",
    "filter": "Phone",
    "tags": "undefined",
    "linkURL": "tel:18669276327",
    "description": "Helpline: peer-operated listening service for people in need of support. The Warmline offers non-crisis supportive listening.\n(4pm-10pm CST)",
    "RID": "00060"
  },
  {
    "linkTitle": "7 Cups",
    "category": "General",
    "linkURL": "https://www.7cups.com/",
    "title": "7 Cups Group Chatline",
    "filter": "LearnAbout",
    "tags": "undefined",
    "RID": "00061",
    "description": "Website: Provides virtual counseling and listening services to people in need of support."
  },
  {
    "linkTitle": "I've Lost Someone",
    "tags": "undefined",
    "linkURL": "https://afsp.org/ive-lost-someone",
    "description": "Website: Providing support and resources to people who have lost loved ones or friends to suicide.",
    "title": "I've Lost Someone",
    "RID": "00063",
    "category": "GriefLoss",
    "filter": "LearnAbout"
  },
  {
    "linkTitle": "NYP BPD",
    "category": "Misc",
    "tags": "undefined",
    "RID": "00064",
    "linkURL": "https://www.nyp.org/bpdresourcecenter",
    "title": "Borderline Personality Disorder Resource Center",
    "religious": false,
    "filter": "LearnAbout",
    "description": "Website: Promoting education about borderline personality disorders and connect those affected by BPD to resources for treatment and support."
  },
  {
    "category": "Misc",
    "linkURL": "http://sczaction.org",
    "title": "Schizophrenia and Psychosis Action Alliance",
    "filter": "LearnAbout",
    "religious": false,
    "tags": "undefined",
    "linkTitle": "S&P AA",
    "description": "Website: Providing support, information, and advocacy for people who are living with schizophrenia and psychosis",
    "RID": "00065"
  },
  {
    "linkURL": "tel:18004932094",
    "description": "Helpline: Providing support and resources for people living with schizophrenia/psychosis.\n(M-F 9am-5pm CST)",
    "RID": "00066",
    "linkTitle": "1(800) 493-2094",
    "title": "Schizophrenia and Psychosis Action Alliance",
    "religious": false,
    "tags": "undefined",
    "filter": "Phone",
    "category": "Misc"
  },
  {
    "tags": "undefined",
    "category": "Men",
    "title": "Man Therapy",
    "description": "Website: A comprehensive and straightforward resource for various aspects of men's mental health. Made by men for men. ",
    "RID": "00067",
    "linkTitle": "Man Therapy",
    "linkURL": "https://mantherapy.org/",
    "filter": "LearnAbout"
  },
  {
    "tags": "undefined",
    "description": "Website: Organization whose mission is to reach men and boys with health awareness and disease prevention tools, screening programs, and education.",
    "RID": "00068",
    "title": "Men's Health Network",
    "category": "Men",
    "linkTitle": "Men's Health Network",
    "linkURL": "https://menshealthnetwork.org/",
    "filter": "LearnAbout"
  },
  {
    "tags": "undefined",
    "title": "Face it Foundation",
    "description": "Website: The Face it Foundation gives men the support they need to recover from depression.",
    "category": "Men",
    "linkURL": "https://www.faceitfoundation.org/",
    "filter": "Families",
    "RID": "00069",
    "linkTitle": "Face it Foundation"
  },
  {
    "tags": "undefined",
    "title": "Therapy for Black Men",
    "linkTitle": "Therapy for Black Men",
    "linkURL": "https://therapyforblackmen.org/",
    "description": "Service: Connecting black men with culturally competent therapists and working to break the stigma that asking for help is a sign of weakness.",
    "category": "AfricanAmerican",
    "RID": "00071",
    "religious": false,
    "filter": "Services"
  },
  {
    "religious": false,
    "filter": "Services",
    "category": "AfricanAmerican",
    "description": "Service: Helping to connect black men with culturally competent therapists.\n(8am-4pm CST)",
    "title": "Therapy for Black Men",
    "RID": "00073",
    "linkTitle": "1(646) 780-8278",
    "tags": "undefined",
    "linkURL": "tel:16467808278"
  },
  {
    "category": "Men",
    "linkURL": "http://postpartummen.com/",
    "tags": "undefined",
    "RID": "00074",
    "filter": "LearnAbout",
    "title": "Postpartum Men",
    "linkTitle": "Postpartum Men",
    "description": "Website: A place for men with concerns about depression, anxiety, or other problems with mood after the birth of a child."
  },
  {
    "description": "Website: Providing support for male survivors of sexual assault, and breaking the stigma that males cannot be affected by sexual assault.",
    "linkTitle": "1 in 6",
    "religious": false,
    "category": "SexualAssualt",
    "RID": "00076",
    "tags": "undefined",
    "title": "1 in 6",
    "filter": "LearnAbout",
    "linkURL": "https://1in6.org/"
  },
  {
    "tags": "undefined",
    "title": "Melanin and Mental Health",
    "linkTitle": "Melanin and Mental Health",
    "category": "BIPOC",
    "filter": "Services",
    "linkURL": "https://www.melaninandmentalhealth.com/",
    "description": "Website: Connecting black and latinx people with culturally competent therapists, and working to take the taboo out of therapy.",
    "RID": "00080"
  },
  {
    "tags": "undefined",
    "RID": "00081",
    "title": "National Youth Crisis Line",
    "linkTitle": "1(800) 448-4663",
    "description": "Helpline: A counseling and referral crisis line for any teen crisis - from pregnancy to drugs to depression.\n(24/7)",
    "linkURL": "tel:18004484663",
    "category": "YouthYoungAdult",
    "filter": "Phone"
  },
  {
    "linkURL": "tel:18554272736",
    "description": "Helpline: Free telephone counselling and support service for parents and caregivers of children aged 0 to 18.\n(M-F 12pm-9pm CST)",
    "linkTitle": "1-855-4APARENT (4272736)",
    "category": "General",
    "tags": "undefined",
    "filter": "Phone",
    "title": "National Parent Hotline",
    "RID": "00082"
  },
  {
    "filter": "Phone",
    "title": "Teen Lifeline",
    "linkTitle": "1(800) 248-TEEN (8336)",
    "linkURL": "tel:18002488336",
    "category": "YouthYoungAdult",
    "tags": "undefined",
    "description": "Helpline: Peer counselor support line that allows teens to talk about their problems to other teens who will better understand and help.\n(24/7)",
    "RID": "00083"
  },
  {
    "category": "BIPOC",
    "linkTitle": "Steve Fund",
    "filter": "LearnAbout",
    "title": "The Steve Fund Website",
    "RID": "00087",
    "description": "Website: Leading organization promoting the mental health and emotional well-being of young people of color.",
    "linkURL": "https://www.stevefund.org/",
    "tags": "undefined"
  },
  {
    "linkURL": "https://prettybrowngirl.com/",
    "RID": "00090",
    "filter": "LearnAbout",
    "description": "Website: Educating and empowering girls of color by encouraging self-acceptance while cultivating social, emotional, and intellectual wellbeing.",
    "tags": "undefined",
    "title": "Pretty Brown Girl",
    "linkTitle": "Pretty Brown Girl",
    "category": "BIPOC"
  },
  {
    "category": "AfricanAmerican",
    "linkURL": "https://oppf.org/byomm/",
    "title": "Brother You're On My Mind",
    "filter": "LearnAbout",
    "religious": false,
    "tags": "undefined",
    "linkTitle": "BYOMM",
    "description": "Website: Changing the National Dialogue Regarding Mental Health Among African American Men, an initiative to help start conversations.",
    "RID": "00092"
  },
  {
    "filter": "LearnAbout",
    "religious": false,
    "RID": "00094",
    "description": "Website: A collective of leaders in various professions committed to the emotional/mental health as well as the healing of black communities.",
    "linkTitle": "BEAM",
    "title": "Black Emotional and Mental Health",
    "linkURL": "https://www.beam.community/",
    "tags": "undefined",
    "category": "AfricanAmerican"
  },
  {
    "title": "Call Black Line",
    "linkURL": "tel:18006045841",
    "tags": "undefined",
    "linkTitle": "1(800) 604-5841",
    "RID": "00095",
    "category": "BIPOC",
    "description": "Hotline: Providing peer support, counseling, witnessing, and affirming the experiences of people affected by systematic oppression.\n(24/7)",
    "filter": "Phone"
  },
  {
    "category": "Latinx",
    "filter": "LearnAbout",
    "linkURL": "https://www.sanamente.org/",
    "RID": "00096",
    "tags": "spanish espanol",
    "title": "SanaMente",
    "religious": false,
    "description": "Website: Spanish language site focused on culturally relevant mental health for Latinx individuals and communities.",
    "linkTitle": "SanaMente"
  },
  {
    "linkURL": "http://www.nlbha.org/",
    "RID": "00097",
    "tags": "undefined",
    "title": "National Latino Behavioral Health Association",
    "linkTitle": "NLBHA",
    "description": "Website: A national voice for Latino populations in the behavioral health arena and bringing attention to disparities in areas of access.",
    "filter": "LearnAbout",
    "category": "Latinx",
    "religious": false
  },
  {
    "tags": "espanol spanish",
    "title": "Life is Precious/ La Vida es preciosa",
    "RID": "00098",
    "religious": false,
    "linkURL": "https://www.comunilifelip.org/",
    "description": "Website: Works to prevent suicide in young Latinas – the teen population with the highest rate of suicide attempt in the country.",
    "filter": "LearnAbout",
    "category": "Latinx",
    "linkTitle": "Life is Precious"
  },
  {
    "filter": "Services",
    "description": "Website: Online tool that makes it easy for Latinx people to find culturally competent mental health professionals in their own communities.",
    "title": "Therapy for Latinx",
    "linkTitle": "Therapy for Latinx",
    "tags": "undefined",
    "RID": "00099",
    "category": "Latinx",
    "religious": false
  },
  {
    "filter": "LearnAbout",
    "tags": "undefined",
    "category": "Latinx",
    "linkURL": "https://www.helpadvisor.com/conditions/salud-mental-de-los-hispanos",
    "RID": "00100",
    "title": "Help Advisor",
    "description": "Website: Expert public health analysis and local Spanish-language resources to help serve Latinx Americans.",
    "religious": false
  },
  {
    "filter": "LearnAbout",
    "tags": "undefined",
    "RID": "00101",
    "linkTitle": "Asian Mental Health Collective",
    "linkURL": "https://www.asianmhc.org/",
    "category": "AAPI",
    "title": "Asian Mental Health Collective",
    "religious": false,
    "description": "Website: Working to raise awareness about mental health care, and challenge the stigma concerning mental illness in Asian communities."
  },
  {
    "linkURL": "https://aapaonline.org/",
    "filter": "LearnAbout",
    "description": "Website: Advancing the mental health and well-being of Asian American communities through research, practice, education, and policy.",
    "title": "Asian American Psychological Association",
    "tags": "undefined",
    "linkTitle": "AAPA",
    "RID": "00103",
    "category": "AAPI",
    "religious": false
  },
  {
    "title": "National AAPI Mental Health Association",
    "description": "Website: Provides mental health and behavioral services for Asian Americans, Native Hawaiians, and Pacific Islanders.",
    "linkTitle": "NAAPIMHA",
    "linkURL": "https://www.naapimha.org/aanhpi-service-providers",
    "RID": "00105",
    "tags": "undefined",
    "filter": "LearnAbout",
    "category": "AAPI",
    "religious": false
  },
  {
    "linkTitle": "SAMHIN",
    "linkURL": "https://samhin.org/",
    "description": "Website: A nonprofit that addresses the mental health needs of the South Asian community in the U.S.",
    "RID": "00106",
    "title": "South Asian Mental Health Init. and Network",
    "religious": false,
    "filter": "LearnAbout",
    "tags": "undefined",
    "category": "AAPI"
  },
  {
    "tags": "undefined",
    "RID": "00108",
    "title": "Asians Do Therapy",
    "category": "AAPI",
    "filter": "Services",
    "linkTitle": "Asians Do Therapy",
    "description": "Website: Dedicated to reducing stigma and increasing accessibility to mental health resources for the Asian community.",
    "linkURL": "https://asiansdotherapy.com/",
    "religious": false
  },
  {
    "filter": "Services",
    "religious": false,
    "linkURL": "https://www.ihs.gov/suicideprevention/",
    "tags": "undefined",
    "title": "Native American Suicide Prevention",
    "RID": "00109",
    "linkTitle": "Indian Health Service",
    "description": "Website: National initiative on suicide prevention, based on collaborations across Tribes, Tribal orgs, Urban Indian orgs, and the IHS.",
    "category": "Indigenous"
  },
  {
    "filter": "LearnAbout",
    "linkTitle": "We R Native",
    "linkURL": "https://www.wernative.org/",
    "religious": false,
    "RID": "00110",
    "description": "Website: A comprehensive health resource for Native youth, by Native youth, providing content about the topics that matter most to them.",
    "tags": "undefined",
    "category": "Indigenous",
    "title": "We R Native"
  },
  {
    "category": "YouthYoungAdult",
    "filter": "Phone",
    "linkTitle": "1(800) 4ACHILD (4224453)",
    "linkURL": "tel:18004224453",
    "RID": "00117",
    "religious": false,
    "tags": "undefined",
    "title": "Childhelp",
    "description": "Helpline: Helping people who are being hurt, know someone who might be hurting, or are afraid you might hurt another.\n(24/7)"
  },
  {
    "description": "Website: A 12 step fellowship for the family and friends of those individuals with\ndrug, alcohol, or related behavioral issues.",
    "RID": "00123",
    "title": "Families Anonymous",
    "category": "SubstanceAbuse",
    "filter": "Families",
    "linkTitle": "Families Anonymous",
    "linkURL": "https://www.familiesanonymous.org/",
    "tags": "undefined"
  },
  {
    "tags": "undefined",
    "linkTitle": "Melanin and Mental Health",
    "title": "Melanin and Mental Health",
    "description": "Website: Connecting individuals with culturally competent clinicians committed to serving Black & Latinx/Hispanic communities.",
    "filter": "LearnAbout",
    "linkURL": "https://www.melaninandmentalhealth.com/",
    "RID": "00124",
    "category": "BIPOC"
  },
  {
    "linkURL": "https://asianmentalhealthproject.com/",
    "religious": false,
    "description": "Website: Aims to educate and empower Asian communities in seeking mental healthcare, as well as breaking the stigma surrounding mental health.",
    "tags": "undefined",
    "RID": "00132",
    "category": "AAPI",
    "title": "Asian Mental Health Project",
    "filter": "LearnAbout",
    "linkTitle": "Asian Mental Health Project"
  },
  {
    "tags": "undefined",
    "filter": "LearnAbout",
    "linkTitle": "Twelve Talks",
    "title": "Twelve Talks To Have With Teens",
    "category": "SubstanceAbuse",
    "linkURL": "https://www.twelvetalks.com/",
    "description": "Website: A great for parents to get guidance on how to have good conversations with teens about drugs, alcohol, and setting boundaries.",
    "RID": "00137"
  },
  {
    "RID": "00139",
    "tags": "undefined",
    "linkURL": "https://psichapters.com/",
    "filter": "Families",
    "linkTitle": "Postpartum Support Internaional",
    "title": "Postpartum Support International",
    "category": "Pregnancy",
    "description": "Website: Connecting new parents with peers and professionals who can guide them through the challenge of becoming new parents."
  },
  {
    "title": "Make The Connection",
    "description": "Website: Shares stories of recovery from military veterans and provides resources to help find local support.",
    "RID": "00144",
    "category": "Military",
    "linkURL": "https://www.maketheconnection.net/",
    "linkTitle": "Make The Connection ",
    "filter": "LearnAbout",
    "tags": "undefined"
  },
  {
    "linkURL": "https://www.networkjhsa.org/",
    "religious": false,
    "description": "Website: Has mental health programs for children and adolescents, refugees and underserved Russian-speaking immigrants.",
    "tags": "undefined",
    "RID": "00145",
    "category": "General",
    "title": "Jewish Family Service",
    "filter": "Families",
    "linkTitle": "Jewish Family Services"
  },
  {
    "description": "Website: An online platform that provides information to black women about therapy, and matches them to culturally competent therapists.",
    "linkTitle": "Therapy For Black Girls",
    "filter": "Services",
    "religious": false,
    "linkURL": "https://therapyforblackgirls.com/",
    "tags": "undefined",
    "title": "Therapy For Black Girls ",
    "category": "AfricanAmerican",
    "RID": "00146"
  },
  {
    "title": "Ourselves Black",
    "description": "Website: Information on promoting mental health and developing positive coping mechanisms through a podcast, magazine and discussion groups.",
    "religious": false,
    "linkURL": "http://www.ourselvesblack.com/",
    "linkTitle": "Ourselves Black",
    "tags": "undefined",
    "category": "AfricanAmerican",
    "filter": "LearnAbout",
    "RID": "00149"
  },
  {
    "filter": "LearnAbout",
    "tags": "undefined",
    "RID": "00150",
    "linkTitle": "Florida Rehab",
    "title": "Florida Rehab Alcoholism Treatment Guide",
    "description": "Website: A comprehensive guide on alcohol addiction treatment that highlights signs of alcoholism, and what to expect during treatment.",
    "linkURL": "https://www.floridarehab.com/alcohol/treatment-rehab/",
    "category": "SubstanceAbuse"
  },
  {
    "title": "Coping With Anger",
    "description": "Website: A short overview to learn more about anger, how it can affect you, and what can do to calm down.",
    "tags": "undefined",
    "filter": "LearnAbout",
    "religious": false,
    "category": "Misc",
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-anger/",
    "RID": "00155",
    "linkTitle": "How Right Now"
  },
  {
    "description": "Helpline: HelpLine volunteers are working to answer questions, offer support, and provide practical next steps.\n(M-F 9am-9pm CST)",
    "title": "NAMI HelpLine",
    "tags": "undefined",
    "linkTitle": " 1(800) 950-NAMI (6264)",
    "category": "General",
    "linkURL": "tel:18009506264",
    "filter": "Phone",
    "RID": "00156"
  },
  {
    "RID": "00157",
    "linkTitle": "\"HelpLine\" to 62640",
    "description": "Chatline: HelpLine volunteers are working to answer questions, offer support, and provide practical next steps.\n(M-F 9am-9pm CST)",
    "filter": "Chat",
    "title": "NAMI HelpLine (Chat)",
    "linkURL": "sms:62640",
    "category": "General",
    "tags": "undefined"
  },
  {
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-grief/",
    "description": "Website: A short overview to learn more about grief, what can cause grief, how it can affect you, and what can help.",
    "RID": "00158",
    "title": "Coping with Grief",
    "filter": "LearnAbout",
    "category": "GriefLoss",
    "linkTitle": "How Right Now",
    "tags": "undefined"
  },
  {
    "filter": "LearnAbout",
    "linkTitle": "How Right Now",
    "category": "General",
    "RID": "00159",
    "tags": "undefined",
    "title": "How Right Now",
    "description": "Website: Get access to help, information, and other resources for specific feelings, and general mental health concerns.",
    "linkURL": "https://www.cdc.gov/howrightnow/"
  },
  {
    "title": "Coping With Fear",
    "linkTitle": "How Right Now",
    "filter": "LearnAbout",
    "RID": "00160",
    "religious": false,
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-fear/index.html",
    "category": "Misc",
    "description": "Website: A short overview to learn more about fear, how fear can affect you, and what can help.",
    "tags": "undefined"
  },
  {
    "RID": "00161",
    "linkURL": "https://namisantaclara.org/wp-content/uploads/2020/07/RacialTrauma_FINAL.pdf",
    "title": "The Effects of Racial Trauma on Mental Health",
    "linkTitle": "NAMI Santa Clara",
    "description": "Article: Discusses the impact of historical racial trauma on the mental health of communities of color.",
    "category": "BIPOC",
    "filter": "LearnAbout"
  },
  {
    "linkTitle": "How Right Now",
    "religious": false,
    "description": "Website: A short overview to learn more about loneliness, how being lonely can affect you, and what can help.",
    "tags": "undefined",
    "filter": "LearnAbout",
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-loneliness/index.html",
    "RID": "00162",
    "category": "Misc",
    "title": "Coping with Loneliness"
  },
  {
    "linkTitle": "How Right Now",
    "religious": false,
    "description": "Website: A short overview to learn more about sadness, how sadness can affect you, and what you can do about it.",
    "tags": "undefined",
    "filter": "LearnAbout",
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-sadness/index.html",
    "RID": "00163",
    "category": "Misc",
    "title": "Coping with Sadness"
  },
  {
    "RID": "00164",
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-stress/index.html",
    "religious": false,
    "category": "Misc",
    "title": "Coping with Stress",
    "tags": "undefined",
    "filter": "LearnAbout",
    "linkTitle": "How Right Now",
    "description": "Website: A short overview to learn more about stress, what can cause stress, and what can help alleviate it."
  },
  {
    "title": "Coping with Worry",
    "description": "Website: A short overview to learn more about worry, what can cause worrying, and what can help alleviate it.",
    "tags": "undefined",
    "filter": "LearnAbout",
    "religious": false,
    "category": "Misc",
    "linkURL": "https://www.cdc.gov/howrightnow/resources/coping-with-worry/index.html",
    "linkTitle": "How Right Now",
    "RID": "00165"
  },
  {
    "title": "What is Depression?",
    "category": "Depression",
    "linkTitle": "NIMH",
    "description": "Website: Basic information about depression, the different types of depression, how it affects people, and how to get help.",
    "religious": false,
    "RID": "00166",
    "filter": "LearnAbout",
    "tags": "undefined",
    "linkURL": "https://www.nimh.nih.gov/health/topics/depression"
  },
  {
    "linkTitle": "NIMH",
    "religious": false,
    "linkURL": "https://www.nimh.nih.gov/health/topics/anxiety-disorders",
    "category": "Anxiety",
    "filter": "LearnAbout",
    "RID": "00167",
    "description": "Website: Providing basic and advanced information about anxiety, as well as symptoms and treatment options.",
    "tags": "undefined",
    "title": "What is Anxiety?"
  },
  {
    "linkTitle": "NIMH",
    "filter": "LearnAbout",
    "description": "Website: Providing basic and advanced information about Post-Traumatic Stress Disorder, as well as symptoms and treatment options.",
    "RID": "00168",
    "title": "What is PTSD?",
    "religious": false,
    "tags": "undefined",
    "category": "TraumaPTSD",
    "linkURL": "https://www.nimh.nih.gov/health/topics/post-traumatic-stress-disorder-ptsd"
  },
  {
    "linkURL": "https://www.nimh.nih.gov/health/topics/substance-use-and-mental-health",
    "description": "Website: Providing basic and advanced information about substance abuse, as well as treatment options.",
    "title": "What is Substance Abuse?",
    "linkTitle": "NIMH",
    "category": "SubstanceAbuse",
    "RID": "00169",
    "filter": "LearnAbout"
  },
  {
    "title": "What are Eating Disorders?",
    "category": "EatingDisorders",
    "filter": "LearnAbout",
    "linkTitle": "NIMH",
    "RID": "00170",
    "description": "Website: Providing basic and advanced information about eating disorders, as well as symptoms and treatment options.",
    "linkURL": "https://www.nimh.nih.gov/health/topics/eating-disorders"
  },
  {
    "title": "What is Bipolar Disorders?",
    "RID": "00171",
    "filter": "LearnAbout",
    "linkTitle": "NIMH",
    "category": "Bipolar",
    "description": "Website: Providing basic and advanced information about bipolar disorder, as well as symptoms and treatment options.",
    "linkURL": "https://www.nimh.nih.gov/health/topics/bipolar-disorder"
  },
  {
    "title": "What is Autism?",
    "linkURL": "https://www.nimh.nih.gov/health/topics/autism-spectrum-disorders-asd",
    "category": "Autism",
    "linkTitle": "NIMH",
    "RID": "00172",
    "filter": "LearnAbout",
    "description": "Website: Providing basic and advanced information about Autism, as well as symptoms and treatment options."
  },
  {
    "RID": "00173",
    "category": "Men",
    "title": "Men and Mental Health",
    "linkTitle": "NIMH",
    "linkURL": "https://www.nimh.nih.gov/health/topics/men-and-mental-health",
    "tags": "undefined",
    "filter": "LearnAbout",
    "description": "Website: Providing information on mental health tailored to help men understand men-specific mental health concerns."
  },
  {
    "tags": "undefined",
    "category": "Women",
    "description": "Website: Providing information on mental health tailored to help women understand women-specific mental health concerns.",
    "title": "Women and Mental Health",
    "RID": "00174",
    "filter": "LearnAbout",
    "linkTitle": "NIMH",
    "linkURL": "https://www.nimh.nih.gov/health/topics/women-and-mental-health"
  },
  {
    "description": "Website: Providing information on mental health that has been tailored for adults and the older population.",
    "tags": "undefined",
    "linkURL": "https://www.nimh.nih.gov/health/topics/older-adults-and-mental-health",
    "linkTitle": "NIMH",
    "religious": false,
    "RID": "00175",
    "title": "Mental Health in Older Adults",
    "category": "Misc",
    "filter": "LearnAbout"
  },
  {
    "religious": false,
    "linkTitle": "NIMH",
    "RID": "00176",
    "linkURL": "https://www.nimh.nih.gov/health/topics/coping-with-traumatic-events",
    "tags": "undefined",
    "description": "Website: Providing information about trauma, and how to cope (or help someone else) after experiencing trauma.",
    "title": "What is Trauma?",
    "category": "TraumaPTSD",
    "filter": "LearnAbout"
  },
  {
    "RID": "00177",
    "description": "Website: Information about how to talk about mental health, and how to listen and start a conversation.",
    "linkTitle": "How Right Now",
    "category": "General",
    "filter": "LearnAbout",
    "linkURL": "https://www.cdc.gov/howrightnow/talk/index.html?utm_source=HowRightNow&utm_medium=HRNwebsite",
    "title": "How to Talk About Mental Health",
    "tags": "undefined"
  },
  {
    "linkTitle": "Mental Health America",
    "filter": "LearnAbout",
    "linkURL": "https://screening.mhanational.org/screening-tools/anxiety/",
    "RID": "00178",
    "title": "Anxiety Test",
    "religious": false,
    "description": "Screening: Survey that will help you measure, better understand and provide resources for your anxiety.",
    "tags": "undefined"
  },
  {
    "linkTitle": "Mental Health America",
    "filter": "LearnAbout",
    "linkURL": "https://screening.mhanational.org/screening-tools/depression/",
    "title": "Depression Test",
    "tags": "undefined",
    "description": "Screening: Survey that will help you measure, better understand and provide resources for depression.",
    "religious": false,
    "RID": "00179",
    "category": "Depression"
  },
  {
    "linkURL": "https://www.cancer.org/treatment/end-of-life-care/grief-and-loss/depression-and-complicated-grief.html?utm_source=HowRightNow&utm_medium=HRNwebsite",
    "RID": "00180",
    "linkTitle": "American Cancer Society",
    "description": "Article: Provides suggestions on seeking help, and supporting a loved one.",
    "category": "GriefLoss",
    "filter": "LearnAbout",
    "tags": "undefined",
    "title": "Seeking Help During Grief or Loss"
  },
  {
    "RID": "00181",
    "description": "Website: Provides possible ways to offer support to someone who is grieving, and a variety of factors that affect how you can offer support.",
    "tags": "undefined",
    "linkURL": "https://www.ptsd.va.gov/family/how_help_grief.asp",
    "filter": "Families",
    "category": "GriefLoss",
    "title": "Helping Someone Else After a Loss",
    "linkTitle": "Veterans Affairs"
  },
  {
    "linkURL": "https://www.ptsd.va.gov/understand/related/related_problems_grief.asp",
    "title": "Taking Care of Yourself After a Loss",
    "category": "GriefLoss",
    "RID": "00182",
    "description": "Website: Provides strategies and support to mitigate or reduce grief over time following a loss.",
    "filter": "LearnAbout",
    "linkTitle": "Veterans Affairs",
    "tags": "undefined"
  },
  {
    "description": "Helpline: Reach caring, qualified responders with the Department of Veterans Affairs. Many of them are Veterans themselves. \n(24/7)",
    "linkTitle": "988, then press 1",
    "RID": "00183",
    "title": "Veterans Crisis Line",
    "category": "Military",
    "filter": "Phone",
    "linkURL": "tel:988",
    "tags": "undefined"
  },
  {
    "linkURL": "tel:18006564673",
    "description": "Helpline: Provides confidential support and localized resources for people experiencing sexual assault.\n(24/7)",
    "religious": false,
    "filter": "Phone",
    "tags": "undefined",
    "linkTitle": "1(800) 656-HOPE (4673)",
    "title": "National Sexual Assault Helpline",
    "category": "SexualAssualt",
    "RID": "00184"
  },
  {
    "linkURL": "tel:18664887386",
    "linkTitle": "1(866) 488-7386",
    "RID": "00185",
    "title": "Trevor Lifeline",
    "tags": "undefined",
    "category": "LGBTQI",
    "description": "Helpline: Providing crisis intervention and suicide prevention services to lesbian, gay, bisexual, transgender, queer & questioning youth.\n(24/7)",
    "filter": "Phone"
  },
  {
    "title": "Stronghearts Native Helpline",
    "linkTitle": "1(844) 762-8483",
    "filter": "Phone",
    "RID": "00186",
    "religious": false,
    "linkURL": "tel:18447628483",
    "category": "Indigenous",
    "tags": "undefined",
    "description": "Helpline: Providing confidential and anonymous, culturally-appropriate domestic violence and dating violence helpline for Native Americans.\n(24/7)"
  },
  {
    "linkURL": "https://www.standagainsthatred.org/resources?utm_source=HowRightNow&utm_medium=HRNwebsite",
    "RID": "00187",
    "tags": "undefined",
    "religious": false,
    "filter": "LearnAbout",
    "title": "Stand Against Hatred Resources",
    "category": "AAPI",
    "linkTitle": "Asian Americans Advancing Justice",
    "description": "Website: Providing a collection of resources and information about responding to hate and discrimination against the Asian American community."
  },
  {
    "linkTitle": "American Heart Association",
    "description": "Website: Providing ways to help reduce stress with health habits.",
    "title": "Fight Stress with Healthy Habits",
    "filter": "LearnAbout",
    "category": "General",
    "RID": "00189",
    "linkURL": "https://www.heart.org/en/healthy-living/healthy-lifestyle/stress-management/fight-stress-with-healthy-habits-infographic"
  },
  {
    "religious": false,
    "filter": "LearnAbout",
    "linkURL": "https://www.mhanational.org/issues/asian-american-pacific-islander-communities-and-mental-health",
    "tags": "undefined",
    "title": "AAPI Communities and Mental Health",
    "RID": "00190",
    "linkTitle": "Mental Health America",
    "category": "AAPI",
    "description": "Website: Providing information about mental health tailored towards Asian American / Pacific Islander Communities."
  },
  {
    "linkURL": "sms:678678",
    "description": "Chatline: Confidential and secure resource that provides live help for LGBTQ youth with a trained specialist, over text messages.\n(24/7)",
    "category": "LGBTQI",
    "RID": "00191",
    "title": "TrevorText",
    "tags": "undefined",
    "filter": "Chat",
    "linkTitle": "\"START\" to 678-678"
  },
  {
    "description": "Website: Offering suggestions and strategies to reach someone who is experiencing abuse and offer them help.",
    "linkTitle": "WSCASDV",
    "tags": "undefined",
    "linkURL": "https://wscadv.org/resources/supporting-someone-experiencing-abuse/",
    "title": "Supporting Someone Experiencing Abuse",
    "RID": "00192",
    "religious": false,
    "category": "Abuse",
    "filter": "Families"
  },
  {
    "filter": "LearnAbout",
    "RID": "00193",
    "description": "Website: Providing information to help understand anger and its effects as well as how to manage it effectively.",
    "linkTitle": "HelpGuide",
    "linkURL": "https://www.helpguide.org/articles/relationships-communication/anger-management.htm",
    "category": "Misc",
    "title": "Anger Management",
    "tags": "undefined",
    "religious": false
  },
  {
    "description": "Website: Providing information regarding traumatic experiences, how to avoid them, and how they can affect adolescents.",
    "linkTitle": "Child Care Aware",
    "tags": "undefined",
    "linkURL": "https://www.childcareaware.org/our-issues/crisis-and-disaster-resources/tools-publications-and-resources/mass-shooting-and-violence-resources/",
    "title": "Traumatic Events and Children",
    "RID": "00194",
    "religious": false,
    "category": "TraumaPTSD",
    "filter": "LearnAbout"
  },
  {
    "linkTitle": "Trevor Project",
    "description": "Document: Helps readers explore their sexual identity and provides tools and questions to determine what it might be like to come out.\n",
    "filter": "LearnAbout",
    "title": "Coming Out Handbook",
    "category": "LGBTQI",
    "RID": "00195",
    "linkURL": "https://www.thetrevorproject.org/wp-content/uploads/2019/10/Coming-Out-Handbook.pdf"
  },
  {
    "description": "Service: Helps people using narcotics get access to resources or local Narcotics Anonymous chapters and meetings.",
    "linkTitle": "Narcotics Anonymous",
    "linkURL": "https://www.na.org/meetingsearch/",
    "title": "Narcotics Anonymous",
    "filter": "Services",
    "RID": "00196",
    "category": "SubstanceAbuse"
  },
  {
    "title": "Military Helpline",
    "filter": "Phone",
    "linkURL": "tel:8884574838",
    "linkTitle": "(888) 457-4838",
    "description": "Helpline: Provides free and confidential crisis intervention and suicide prevention focused on military-specific issues. (24/7)",
    "category": "Military",
    "tags": "undefined",
    "RID": "00197"
  },
  {
    "filter": "Chat",
    "linkURL": "sms:839863",
    "tags": "undefined",
    "description": "Chatline: Provides free and confidential crisis intervention and suicide prevention focused on military-specific issues. (M-F 4pm-8pm CST)",
    "title": "Military Helpline (Chat)",
    "linkTitle": "\"MIL1\" to 839863",
    "category": "Military",
    "RID": "00198"
  },
  {
    "filter": "Services",
    "category": "General",
    "description": "Website: Providing access to numerous professionally curated resources organized into categories for easy access.",
    "linkURL": "https://www.crisistextline.org/resources/",
    "tags": "undefined",
    "linkTitle": "Crisis Text Line",
    "title": "Crisis Text Line Resource Library",
    "RID": "00199"
  },
  {
    "title": "MHC Resource Library",
    "linkURL": "https://www.thementalhealthcoalition.org/resource-library",
    "description": "Website: Providing access to numerous professionally curated resources organized into categories for easy access.",
    "category": "General",
    "RID": "00200",
    "filter": "Services",
    "linkTitle": "Mental Health Coalition"
  },
  {
    "filter": "LearnAbout",
    "linkURL": "https://uspainfoundation.org/pain/",
    "category": "PainIllness",
    "description": "Website: Provides information, resources, and treatment options for people suffering from chronic pain.",
    "linkTitle": "US Pain Foundation",
    "RID": "00201",
    "title": "Living With Chronic Pain"
  },
  {
    "linkTitle": "(617) 616-1616",
    "linkURL": "tel:6176161616",
    "title": "Sexual Health Counseling & Referral Hotline",
    "filter": "Phone",
    "RID": "00202",
    "description": "Helpline: Provides callers with counseling and treatment options for all things sexual health.\n(M, W, F 8am-3pm CST)",
    "religious": false,
    "tags": "undefined",
    "category": "Misc"
  },
  {
    "linkTitle": "1in6",
    "description": "Chatline: Providing support and help for men who've experienced sexual assault, or friends of someone who has.",
    "tags": "undefined",
    "linkURL": "http://1in6.org/helpline",
    "title": "1in6 Male Sexual Assault Chat",
    "category": "SexualAssualt",
    "filter": "Chat",
    "RID": "00203",
    "religious": false
  },
  {
    "linkURL": "https://teenlifeline.org/my-student-needs-help/",
    "linkTitle": "Teen Lifeline",
    "category": "YouthYoungAdult",
    "filter": "LearnAbout",
    "RID": "00204",
    "title": "My Student Needs Help",
    "description": "Website: Providing information to educators and school staff on how they can aid in helping a student during a mental health crisis."
  },
  {
    "title": "Helping Someone with Body Dysmorphia",
    "description": "Website: Advice for friends and family on how to support someone with body dysmorphic disorder (BDD).",
    "religious": false,
    "linkTitle": "Mind",
    "tags": "undefined",
    "linkURL": "https://www.mind.org.uk/information-support/types-of-mental-health-problems/body-dysmorphic-disorder-bdd/for-friends-and-family/",
    "filter": "Families",
    "category": "BodyDysmorphia",
    "RID": "00205"
  },
  {
    "linkURL": "https://bddfoundation.org/information/what-is-bdd/",
    "description": "Website: Providing information about Body Dysmorphic Disorder, what the symptoms are, and what treatments are available.",
    "category": "BodyDysmorphia",
    "tags": "undefined",
    "linkTitle": "BDD Foundation ",
    "title": "What is Body Dysmorphic Disorder (BDD)",
    "religious": false,
    "RID": "00206",
    "filter": "LearnAbout"
  },
  {
    "title": "Body Dysmorphia Helpline",
    "tags": "undefined",
    "religious": false,
    "description": "Helpline: Email with a trained BDD Foundation volunteer who can provide support and provide resource referrals.",
    "RID": "00207",
    "filter": "Chat",
    "linkURL": "https://bddfoundation.org/support/online-support/email-helpline/",
    "category": "BodyDysmorphia",
    "linkTitle": "BDD Foundation "
  },
  {
    "description": "Helpline: Licensed, clinical social worker and trained staff — including a Spanish-speaking expert — understand arthritis.\n(M-F 8am-4pm CST)",
    "linkTitle": "Arthritis Helpline",
    "religious": false,
    "title": "Arthritis Foundation Helpline",
    "linkURL": "tel:18002837800",
    "RID": "00208",
    "category": "PainIllness",
    "filter": "Phone"
  },
  {
    "RID": "00209",
    "title": "What is Self Harm?",
    "linkURL": "https://www.mind.org.uk/information-support/types-of-mental-health-problems/self-harm/about-self-harm/",
    "tags": "undefined",
    "description": "Website: Providing information about self-harm, why people self-harm, ways people self-harm, and how to get treatment.",
    "category": "SelfHarm",
    "religious": false,
    "filter": "LearnAbout",
    "linkTitle": "Mind"
  },
  {
    "category": "AAPI",
    "filter": "Services",
    "linkTitle": "Asians for Mental Health",
    "RID": "00210",
    "religious": false,
    "title": "Asians for Mental Health Therapist Directory",
    "description": "Service: Helps match Asians to culturally competent therapists, with filters to aid in finding a good match.",
    "linkURL": "https://asiansformentalhealth.com/"
  },
  {
    "title": "Black Girls Smile",
    "linkTitle": "Black Girls Smile",
    "linkURL": "https://www.blackgirlssmile.org/",
    "filter": "LearnAbout",
    "description": "Website: Black Girls Smile provides gender and culturally specific mental wellness education, resources, and support for Black women and girls.",
    "religious": false,
    "RID": "00211",
    "category": "AfricanAmerican"
  },
  {
    "title": "DMHS Provider Directory",
    "description": "Service: Provides listings for hundreds of Black, PoC, AAPI, Latinx, Indigenous, etc. mental health providers.",
    "linkURL": "https://dmhsus.org/find-a-bipoc-therapist-or-healer/",
    "religious": false,
    "filter": "Services",
    "linkTitle": "DMHS",
    "category": "BIPOC",
    "RID": "00212"
  },
  {
    "description": "Service: Connects Latinx people with culturally competent therapists, searchable by location, culture, and specialties.",
    "linkTitle": "Latinx Therapy",
    "filter": "Services",
    "title": "Latinx Therapy",
    "linkURL": "https://latinxtherapy.com/find-a-therapist/",
    "religious": false,
    "RID": "00213",
    "category": "Latinx"
  },
  {
    "linkURL": "https://www.freeblacktherapy.org",
    "religious": false,
    "description": "Service: Free Black Therapy is intended for Black or African American people who lack adequate health insurance and cannot afford therapy.",
    "category": "AfricanAmerican",
    "filter": "Services",
    "RID": "00214",
    "linkTitle": "Free Black Therapy",
    "title": "Free Black Therapy"
  },
  {
    "category": "AAPI",
    "religious": false,
    "title": "South Asian Therapists",
    "linkTitle": "South Asian Therapists",
    "linkURL": "https://southasiantherapists.org/",
    "filter": "Services",
    "RID": "00215",
    "description": "Service: Connecting people of South Asian Descent with culturally competent therapists, with search by language available."
  },
  {
    "filter": "Services",
    "linkURL": "https://zencare.co/",
    "category": "General",
    "religious": false,
    "linkTitle": "Zencare Therapist Directory",
    "RID": "00216",
    "title": "Zencare Therapist Directory",
    "description": "Service: Find a therapist based on location as well as profession, specialty, identity, and approach."
  },
  {
    "description": "Service: View thousands of therapists, and find a match based on location and filters such as age group and specialty.",
    "filter": "Services",
    "RID": "00217",
    "religious": false,
    "title": "TruCircle Therapist Directory",
    "linkURL": "https://mytrucircle.com/",
    "linkTitle": "TruCircle",
    "category": "General"
  },
  {
    "filter": "Phone",
    "category": "GriefLoss",
    "title": "Friends for Survival",
    "religious": false,
    "linkTitle": "1(800) 646-7322",
    "description": "Helpline: Providing confidential support and information for those grieving the suicide death of family or friends.\n(24/7)",
    "RID": "00218",
    "linkURL": "tel:8006467322"
  },
  {
    "RID": "00219",
    "linkTitle": "\"CONNECT\" to 741741",
    "filter": "Chat",
    "title": "Crisis Text Line Self Harm",
    "religious": false,
    "description": "Chatline: Text to connect with a trained counselor about healthy coping mechanisms and alternatives to self harm. ",
    "linkURL": "sms:741741",
    "category": "SelfHarm"
  },
  {
    "category": "SelfHarm",
    "linkURL": "https://www.selfinjury.bctr.cornell.edu/perch/resources/how-can-i-help-a-friend-english.pdf",
    "linkTitle": "Cornell Research",
    "RID": "00220",
    "title": "How can I help a friend who self-injures?",
    "description": "Article: Provides guidance for friends and family to approach, and provide help to a person they think might be self harming.",
    "religious": false,
    "filter": "Families"
  },
  {
    "tags": "undefined",
    "description": "Website: Provides many research articles and resources related to self harm.",
    "title": "Cornell Self-injury & Recovery Resources",
    "category": "SelfHarm",
    "RID": "00221",
    "filter": "LearnAbout",
    "linkURL": "https://www.selfinjury.bctr.cornell.edu/resources.html",
    "linkTitle": "Cornell SIRR",
    "religious": false
  },
  {
    "religious": false,
    "description": "Website: Provides resources and information about mental health in the construction industry, which has an extremely high suicide rate.",
    "filter": "LearnAbout",
    "category": "Misc",
    "RID": "00222",
    "title": "Construction Alliance for Suicide Prevention",
    "linkURL": "https://preventconstructionsuicide.com/",
    "linkTitle": "CIASP"
  },
  {
    "linkURL": "https://hotline.rainn.org/online",
    "linkTitle": "RAINN",
    "category": "SexualAssualt",
    "RID": "00223",
    "filter": "Chat",
    "religious": false,
    "description": "Chatline: Provides confidential support and localized resources for people experiencing sexual assault. (24/7)",
    "title": "RAINN National Sexual Assault Chatline"
  },
  {
    "religious": false,
    "title": "LifeStance Health Provider Finder",
    "category": "General",
    "tags": "",
    "RID": "00224",
    "filter": "Services",
    "description": "Service: LifeStance Health makes it easy to find a therapist or psychiatrist that fits your needs at a location that is convenient for you.",
    "linkTitle": "LifeStance Health",
    "linkURL": "https://lifestance.com/"
  },
  {
    "linkURL": "https://www.cordiscosaile.com/navigating-child-sex-abuse/",
    "description": "Article: Navigating Child Sexual Abuse: A Resource for Survivors and Their Loved Ones provides information about child sexual abuse.",
    "RID": "00225",
    "religious": false,
    "linkTitle": "Cordisco & Saile",
    "title": "Navigating Child Sexual Abuse",
    "category": "SexualAssualt",
    "filter": "LearnAbout"
  },
  {
    "linkTitle": "CDC",
    "category": "General",
    "description": "Website: An article reviewing eight practical steps to take care of and boost your mental well-being.",
    "linkURL": "https://www.cdc.gov/emotional-well-being/improve-your-emotional-well-being/index.html",
    "religious": false,
    "title": "Improve Your Emotional Well-Being",
    "filter": "LearnAbout",
    "tags": "",
    "RID": "00226"
  },
  {
    "category": "SexualAssualt",
    "title": "Child Sexual Abuse Resources",
    "description": "Article: An in depth look at child sexual abuse, how it can occur, the signs, as well as treatment and assistance options for survivors.",
    "linkURL": "https://www.bergmanlegal.com/child-sexual-abuse-resources/",
    "linkTitle": "Bergman Legal",
    "religious": false,
    "filter": "LearnAbout",
    "RID": "00227"
  }
];

/// DATA_MODEL
/// Represents a single mental health resource.
class Resource {
  final bool? religious;
  final String linkURL;
  final String title;
  final String linkTitle;
  final String category;
  final String? tags;
  final String filter;
  final String description;
  final String rid;

  const Resource({
    this.religious,
    required this.linkURL,
    required this.title,
    required this.linkTitle,
    required this.category,
    this.tags,
    required this.filter,
    required this.description,
    required this.rid,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    // Helper function to safely extract string values with default fallback.
    // This is more robust against malformed data (e.g., non-string types)
    // by explicitly checking type and providing a default instead of throwing errors.
    String getString(
      Map<String, dynamic> jsonMap,
      String key,
      String defaultValue,
    ) {
      final Object? value = jsonMap[key];
      if (value == null || value is! String || value == 'undefined') {
        return defaultValue;
      }
      return value;
    }

    String? getNullableString(Map<String, dynamic> jsonMap, String key) {
      final Object? value = jsonMap[key];
      if (value == null || value is! String || value == 'undefined') {
        return null;
      }
      return value;
    }

    return Resource(
      religious: json['religious'] as bool?,
      linkURL: getString(json, 'linkURL', 'https://example.com/missing-link'),
      title: getString(json, 'title', 'Unnamed Resource'),
      linkTitle: getString(json, 'linkTitle', 'Access Resource'),
      category: getString(json, 'category', 'Uncategorized'),
      tags: getNullableString(json, 'tags'), // Use the new helper
      filter: getString(json, 'filter', 'Other'),
      description: getString(json, 'description', 'No description provided.'),
      rid: getString(json, 'RID', 'UNKNOWN_ID'),
    );
  }
}

/// Helper class for combined filter options in the dropdown.
class FilterOption {
  final String display;
  final String value; // The actual category or filter tag string
  final bool isCategory; // True if it's a category, false if it's a filter tag

  const FilterOption({
    required this.display,
    required this.value,
    required this.isCategory,
  });
}

/// Represents a single recommendation.
class Recommendation {
  final String title;
  final String description;
  final String url;

  const Recommendation({
    required this.title,
    required this.description,
    required this.url,
  });

  // Equality and hashCode for Set operations
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recommendation &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          url == other.url; // Assuming title and URL uniquely identify a recommendation

  @override
  int get hashCode => Object.hash(title, url);
}

/// DATA_MODEL
/// Manages the state for resources, including filtering and searching.
class ResourceData extends ChangeNotifier {
  final List<Resource> _allResources;

  String _searchQuery = '';
  String _selectedCategoryFilter = 'All';
  String _selectedFilterTag = 'All';

  ResourceData()
      : _allResources = [...localResources, ...additionalResources] // Combined the two lists here
            .map<Resource>((Map<String, dynamic> json) => Resource.fromJson(json))
            .toList();

  String get searchQuery => _searchQuery;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get selectedFilterTag => _selectedFilterTag;

  // Added getter for allResources for external access (e.g., featured resources)
  List<Resource> get allResources => List<Resource>.unmodifiable(_allResources);

  // New getter for the currently displayed value in the combined dropdown.
  // It returns the value that corresponds to the active filter,
  // or 'All' if both category and tag filters are 'All'.
  String get currentlyDisplayedCombinedFilter {
    if (_selectedCategoryFilter != 'All') {
      return _selectedCategoryFilter;
    }
    if (_selectedFilterTag != 'All') {
      return _selectedFilterTag;
    }
    return 'All';
  }

  // New setter for combined filter selection from a single dropdown.
  void setCombinedFilterSelection(String? selectedValue) {
    if (selectedValue == null || selectedValue == 'All') {
      _selectedCategoryFilter = 'All';
      _selectedFilterTag = 'All';
    } else {
      // Find the FilterOption that matches the selectedValue to determine its type
      final FilterOption? chosenOption = combinedFilterOptions.firstWhereOrNull(
        (FilterOption option) => option.value == selectedValue,
      );

      if (chosenOption != null) {
        if (chosenOption.isCategory) {
          _selectedCategoryFilter = chosenOption.value;
          _selectedFilterTag = 'All'; // Reset the other filter dimension
        } else {
          // It's a filter tag
          _selectedFilterTag = chosenOption.value;
          _selectedCategoryFilter = 'All'; // Reset the other filter dimension
        }
      } else {
        // Fallback: If selectedValue is not found (should not happen with correct data),
        // revert to 'All' for both filters.
        _selectedCategoryFilter = 'All';
        _selectedFilterTag = 'All';
      }
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void setSelectedCategoryFilter(String? filter) {
    if (filter != null && _selectedCategoryFilter != filter) {
      _selectedCategoryFilter = filter;
      notifyListeners();
    }
  }

  void setSelectedFilterTag(String? tag) {
    // New setter for the 'filter' field
    if (tag != null && _selectedFilterTag != tag) {
      _selectedFilterTag = tag;
      notifyListeners();
    }
  }

  // This getter is available for a combined filtered list,
  // but TabBarView children still re-filter for their specific category.
  List<Resource> get filteredResources {
    return _allResources.where((Resource resource) {
      final String lowerCaseQuery = _searchQuery.toLowerCase();
      final bool matchesSearch =
          resource.title.toString().toLowerCase().contains(lowerCaseQuery) ||
          resource.description.toString().toLowerCase().contains(
            lowerCaseQuery,
          ) ||
          (resource.tags?.toLowerCase().contains(lowerCaseQuery) ?? false);

      final bool matchesCategory =
          _selectedCategoryFilter == 'All' ||
          resource.category == _selectedCategoryFilter;

      final bool matchesFilterTag =
          _selectedFilterTag == 'All' || resource.filter == _selectedFilterTag;

      return matchesSearch && matchesCategory && matchesFilterTag;
    }).toList();
  }

  List<String> get uniqueCategories {
    final SplayTreeSet<String> categories = SplayTreeSet<String>();
    for (final Resource resource in _allResources) {
      categories.add(resource.category);
    }
    return <String>['All', ...categories];
  }

  List<String> get uniqueFilterTags {
    // New getter for unique 'filter' values
    final SplayTreeSet<String> tags = SplayTreeSet<String>();
    for (final Resource resource in _allResources) {
      tags.add(resource.filter);
    }
    return <String>['All', ...tags];
  }

  // New getter for the combined list of filter options for the single dropdown
  List<FilterOption> get combinedFilterOptions {
    final List<FilterOption> options = <FilterOption>[
      const FilterOption(
        display: 'All Categories & Types',
        value: 'All',
        isCategory: false,
      ),
    ];

    // Add unique sorted categories
    final SplayTreeSet<String> categoriesSet = SplayTreeSet<String>();
    for (final Resource resource in _allResources) {
      categoriesSet.add(resource.category);
    }
    for (final String category in categoriesSet) {
      options.add(
        FilterOption(
          display: 'Category: $category',
          value: category,
          isCategory: true,
        ),
      );
    }

    // Add unique sorted filter tags
    final SplayTreeSet<String> tagsSet = SplayTreeSet<String>();
    for (final Resource resource in _allResources) {
      tagsSet.add(resource.filter);
    }
    for (final String tag in tagsSet) {
      options.add(
        FilterOption(display: 'Type: $tag', value: tag, isCategory: false),
      );
    }

    return options;
  }

  void clearAllFilters() {
    _searchQuery = '';
    _selectedCategoryFilter = 'All';
    _selectedFilterTag = 'All';
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ResourceData>(
          create: (BuildContext context) => ResourceData(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (BuildContext context) => ChatProvider(),
        ),
        ChangeNotifierProvider<SessionProvider>(
          create: (BuildContext context) => SessionProvider(),
        ),
      ],
      // Using 'builder' to explicitly place the MyApp widget subtree under the provider.
      // This ensures MyApp's context (and subsequently MaterialApp's and its routes')
      // has access to ResourceData and ChatProvider.
      builder: (BuildContext context, Widget? child) {
        return const MainApp();
      },
    ),
  );
}

// Global utility for launching URLs, now with BuildContext for SnackBar feedback.
Future<void> _launchURL(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    // Show a user-friendly error message using a SnackBar
    // Check if the context is still valid before showing SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open link: $url'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
    // ignore: avoid_print
    print('Could not launch $url'); // Still log for debugging
  }
}

/// Helper for icons, mapping categories to appropriate IconData.
IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'Crisis Hotline':
    case 'Crisis Text Support':
    case 'LGBTQ+ Youth Crisis Support':
    case 'Statewide Crisis Hotline':
    case 'State Crisis Hotline':
    case 'Transgender Support Hotline':
    case 'Child/Family Crisis Hotline':
    case 'Runaway/Youth Support':
    case 'Peer Support Hotline':
    case 'Child Abuse Crisis Hotline':
    case 'Crisis':
      return Icons.emergency_outlined;
    case 'Helpline / Peer Support':
    case 'Mental Health/Substance-Use Referral Line':
    case 'Community Resource Hotline':
    case 'Phone':
    case 'General':
      return Icons.phone_in_talk;
    case 'Information/Education':
    case 'Youth Mental Health Advocacy':
    case 'Government Resource':
    case 'Information / Research':
    case 'Information (Professional)':
    case 'Information (Pediatrics)':
    case 'Training/Education':
    case 'LearnAbout':
      return Icons.school;
    case 'Eating Disorders Support':
    case 'EatingDisorders':
    case 'Health':
      return Icons.fastfood_outlined;
    case 'Sexual Assault Support':
    case 'SexualAssualt':
      return Icons.healing;
    case 'Teen Dating Violence Hotline':
    case 'Abuse':
      return Icons.heart_broken_outlined;
    case 'Bullying Prevention (Government)':
    case 'Bullying':
      return Icons.group_off;
    case 'Grief Support':
    case 'GriefLoss':
      return Icons.sentiment_dissatisfied;
    case 'Online Therapy (City Program)':
    case 'Telehealth':
      return Icons.monitor_weight_outlined;
    case 'Treatment Locator':
    case 'Locator':
    case 'Services':
      return Icons.location_on;
    case 'Maternal Mental Health Support':
    case 'Pregnancy':
      return Icons.pregnant_woman;
    case 'Mental Health Info (Spanish)':
    case 'Spanish':
    case 'Latinx':
      return Icons.language;
    case 'Peer Advocacy':
    case 'PeerSupport':
      return Icons.diversity_2;
    case 'SubstanceUse':
    case 'SubstanceAbuse':
      return Icons.local_drink;
    case 'LGBTQ':
    case 'LGBTQI':
      return Icons.people;
    case 'Advocacy':
      return Icons.campaign;
    case 'Trauma':
    case 'TraumaPTSD':
      return Icons.psychology;
    case 'Family':
    case 'Families':
      return Icons.family_restroom;
    case 'Runaway':
      return Icons.directions_run;
    case 'SuicidePrevention':
      return Icons.warning_amber;
    case 'BIPOC':
    case 'AfricanAmerican':
    case 'AAPI':
    case 'Indigenous':
      return Icons.group;
    case 'YouthYoungAdult':
    case 'Teens':
      return Icons.child_care;
    case 'Anxiety':
      return Icons.flare;
    case 'Autism':
      return Icons.psychology_alt;
    case 'Bipolar':
      return Icons.mood_bad;
    case 'Depression':
      return Icons.cloud;
    case 'Men':
      return Icons.man;
    case 'Women':
      return Icons.woman;
    case 'BodyDysmorphia':
      return Icons.accessibility_new;
    case 'SelfHarm':
      return Icons.self_improvement;
    case 'PainIllness':
      return Icons.sick;
    case 'Chat':
      return Icons.chat;
    case 'Military':
      return Icons.military_tech_outlined;
    case 'Misc':
      return Icons.category_outlined;
    case 'Transgender': // Added Transgender category with a people icon
      return Icons.transgender;
    default:
      return Icons.self_improvement; // Default icon
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindWell Connect', 
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Color scheme with gold accents
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
          secondary: const Color(0xFF028d8d), // Gold color
          error: Colors.red,
          tertiary: Colors.teal.shade100,
          surfaceContainerHighest: Colors.teal.shade50,
        ),
        // Input decoration theme with gold borders
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF028d8d), width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF028d8d), width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF028d8d), width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        // Card theme with gold borders
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            side: BorderSide(color: Color(0xFF028d8d), width: 1.0),
          ),
        ),
        // Button themes with gold borders
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Color(0xFF028d8d), width: 1.0),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
            side: const BorderSide(color: Color(0xFF028d8d), width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal,
          ),
        ),
        // Chip theme with gold borders
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade100,
          side: const BorderSide(color: Color(0xFF028d8d), width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF008080),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
          bodySmall: TextStyle(fontSize: 12.0),
          labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: const AppRoot(),
    );
  }
}

/// AppRoot widget that decides whether to show splash screen or main app
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    if (!sessionProvider.hasShownSplash) {
      return SplashScreen(
        onAnimationComplete: () {
          sessionProvider.markSplashAsShown();
        },
      );
    }

    return const HomeScreen();
  }
}

// New widget for the home screen's content (overview)
class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key, required this.onExploreAllResources});

  final VoidCallback onExploreAllResources;

  @override
  Widget build(BuildContext context) {
    final ResourceData resourceData = Provider.of<ResourceData>(context);

    // Define a list of RIDs for featured resources
    // Now simply picks the first few resources from allResources
    final List<Resource> featuredResources =
        resourceData.allResources.take(7).toList();

    final double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your Guide to Mental Well-being',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Find support and information for mental health.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Container(
            height:
                screenHeight * 0.35, // Adjusted for better screen utilization
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              // Added ClipRRect for rounded corners on image
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/Homescreen.png',
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          size: screenHeight * 0.1,
                          color: Colors.grey,
                        ),
                      );
                    },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Immediate Support',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                const ImmediateSupportSection(),
                const SizedBox(height: 20),
                Text(
                  'Featured Resources',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(
            height: 220, // Fixed height for horizontal scroll
            // Removed: Loading indicators and error messages, as data is now local.
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredResources.length,
              itemBuilder: (BuildContext context, int index) {
                return FeaturedResourceCard(
                    resource: featuredResources[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: onExploreAllResources, // Use the callback here
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Explore All Resources'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// New widget for the Recommendations screen content
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late final TextEditingController _ageController;
  late final TextEditingController _interestsController;
  late final TextEditingController _moodController;

  List<Recommendation> _generatedRecommendations =
      <Recommendation>[]; // Initialized as non-nullable empty list

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _interestsController = TextEditingController();
    _moodController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _interestsController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  Future<void> _generateRecommendations() async {
    setState(() {
      _isLoading = true;
      _generatedRecommendations =
          <Recommendation>[]; // Clear previous recommendations
    });

    final String ageInput = _ageController.text.trim();
    final String interestsInput = _interestsController.text.trim().toLowerCase();
    final String moodInput = _moodController.text.trim().toLowerCase();

    final ResourceData resourceData =
        Provider.of<ResourceData>(context, listen: false);

    final List<Resource> allResources = resourceData.allResources;
    final Set<Recommendation> recommendationsSet = <Recommendation>{};

    final int? age = int.tryParse(ageInput);
    final List<String> interestKeywords =
        interestsInput.split(RegExp(r'[,\s]+')).where((String s) => s.isNotEmpty).toList();
    final List<String> moodKeywords =
        moodInput.split(RegExp(r'[,\s]+')).where((String s) => s.isNotEmpty).toList();

    for (final Resource resource in allResources) {
      final String resourceContent =
          '${resource.title.toLowerCase()} ${resource.description.toLowerCase()} ${resource.category.toLowerCase()} ${resource.filter.toLowerCase()} ${resource.tags?.toLowerCase() ?? ''}';
      bool matchesCriteria = false;

      // Age-based matching
      if (age != null) {
        if (age < 18 &&
            (resourceContent.contains('teen') ||
                resourceContent.contains('youth') ||
                resourceContent.contains('child'))) {
          matchesCriteria = true;
        } else if (age >= 18 && age < 25 && resourceContent.contains('young adult')) {
          matchesCriteria = true;
        }
        // For general audience, resources with no specific age filter match any age.
      } else {
        // If age is not provided, consider it generally applicable
        matchesCriteria = true;
      }

      // Keyword matching from interests and mood
      for (final String keyword in interestKeywords) {
        if (resourceContent.contains(keyword)) {
          matchesCriteria = true;
          break;
        }
      }
      for (final String keyword in moodKeywords) {
        if (resourceContent.contains(keyword)) {
          matchesCriteria = true;
          break;
        }
      }

      // If no specific inputs, include general categories
      if (ageInput.isEmpty && interestsInput.isEmpty && moodInput.isEmpty) {
        matchesCriteria = true; // Show all if no filter is applied
      }

      if (matchesCriteria) {
        recommendationsSet.add(Recommendation(
          title: resource.title,
          description: resource.description,
          url: resource.linkURL,
        ));
      }
    }

    // Fallback: If no specific recommendations found, or if input was empty, provide some general useful resources.
    if (recommendationsSet.isEmpty ||
        (ageInput.isEmpty && interestsInput.isEmpty && moodInput.isEmpty)) {
      final List<Resource> generalUsefulResources = allResources.where((Resource r) {
        final String content =
            '${r.title.toLowerCase()} ${r.description.toLowerCase()} ${r.category.toLowerCase()} ${r.filter.toLowerCase()} ${r.tags?.toLowerCase() ?? ''}';
        return content.contains('crisis') ||
            content.contains('helpline') ||
            content.contains('general') ||
            content.contains('info') ||
            content.contains('referral') ||
            content.contains('support');
      }).toList();

      for (int i = 0;
          i < generalUsefulResources.length && recommendationsSet.length < 5;
          i++) {
        recommendationsSet.add(Recommendation(
          title: generalUsefulResources[i].title,
          description: generalUsefulResources[i].description,
          url: generalUsefulResources[i].linkURL,
        ));
      }
    }

    // Sort for consistent display
    _generatedRecommendations = recommendationsSet.toList()
      ..sort((Recommendation a, Recommendation b) => a.title.compareTo(b.title));

    // Simulate network delay (kept for a consistent UX, even without actual network call)
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recommendations generated!',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Get Personalized Recommendations',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tell us a little about yourself to help us find the best resources for you.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Age',
                hintText: 'e.g., 25',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _interestsController,
              maxLines: null, // Allows multiline input
              decoration: InputDecoration(
                labelText: 'Mental Health Interests',
                hintText:
                    'e.g., anxiety, depression, mindfulness, coping skills',
                prefixIcon: const Icon(Icons.lightbulb_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _moodController,
              maxLines: null, // Allows multiline input
              decoration: InputDecoration(
                labelText: 'Current Mood or Concerns',
                hintText:
                    'e.g., feeling stressed, seeking support, want to learn more',
                prefixIcon: const Icon(Icons.mood_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _generateRecommendations,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.search),
                label: Text(
                  _isLoading ? 'Generating...' : 'Get Recommendations',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            if (_generatedRecommendations.isNotEmpty) ...<Widget>[
              const SizedBox(height: 32),
              Text(
                'Here are some recommendations for you:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _generatedRecommendations.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecommendationCard(
                    recommendation: _generatedRecommendations[index],
                  );
                },
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              recommendation.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () => _launchURL(context, recommendation.url),
                icon: const Icon(Icons.link),
                label: Text(
                  recommendation.url.startsWith('tel:') ||
                          recommendation.url.startsWith('sms:')
                      ? 'Contact'
                      : 'Visit Link',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of widgets corresponding to each tab
  late final List<Widget> _pages;

  // List of titles for the AppBar
  static const List<String> _titles = <String>[
    'MindWell Connect',
    'All Resources',
    'Recommendations',
    'Breathing Exercise',
    'Lotus AI',
  ];

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeOverviewScreen(onExploreAllResources: () => _onItemTapped(1)),
      const ResourceListScreen(),
      const RecommendationsScreen(),
      const BreathingExercisePage(), // Changed from StressReductionModulesScreen
      const LotusCompanionScreen(), // AI Chat screen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.spa_outlined, // A more calming/relevant icon
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30.0,
            ),
            const SizedBox(width: 8),
            Text(
              _titles[_selectedIndex], // Dynamic title based on selected tab
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .appBarTheme
                    .backgroundColor, // Use app bar color for consistency
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Removed 988 Suicide & Crisis Lifeline from the menu
            // Removed Crisis Text Line from the menu
            ListTile(
              leading: Icon(
                Icons.home_outlined,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0); // Switch to Home tab
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt,
                color: Theme.of(context).primaryColor,
              ), // Changed to list icon
              title: const Text('All Resources'),
              onTap: () {
                _onItemTapped(1); // Switch to All Resources tab
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.recommend,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Recommendations'),
              onTap: () {
                _onItemTapped(2); // Switch to Recommendations tab
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.self_improvement, // Icon for meditation
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Breathing Exercise'), // Changed to Breathing Exercise
              onTap: () {
                _onItemTapped(3); // Switch to the new Breathing Exercise tab
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.local_florist, // Lotus flower icon for Lotus AI
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Lotus AI'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LotusCompanionScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('About This App'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                showAboutDialog(
                  context: context,
                  applicationName: 'MindWell Connect', // Updated app name
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 Your Organization',
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'This application provides a curated list of mental health resources to help individuals find support and information quickly and easily. It features helplines, websites, and services for various needs and demographics.',
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LotusCompanionScreen()),
          );
        },
        tooltip: 'Chat with Lotus AI',
        child: const Icon(Icons.local_florist),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Show all tabs
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommendations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement), // Icon for stress reduction
            label: 'Breathe', // Label for the new tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist), // Lotus flower icon
            label: 'Lotus AI',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ImmediateSupportSection extends StatelessWidget {
  const ImmediateSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: ListTile(
            leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
            title: Text(
              '988 Suicide & Crisis Lifeline',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Call or Text 988 anytime for confidential support.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
            onTap: () => _launchURL(context, 'tel:988'),
          ),
        ),
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: ListTile(
            leading: Icon(Icons.message, color: Theme.of(context).primaryColor),
            title: Text(
              'Crisis Text Line',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Text "HOME" to 741741 for 24/7 crisis support.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
            onTap: () => _launchURL(context, 'sms:741741'),
          ),
        ),
      ],
    );
  }
}

class FeaturedResourceCard extends StatelessWidget {
  const FeaturedResourceCard({super.key, required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              _getCategoryIcon(resource.category),
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              resource.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              resource.category,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<ResourceDetailScreen>(
                  builder: (BuildContext context) =>
                      ResourceDetailScreen(resource: resource),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  36,
                ), // Full width button
                padding: EdgeInsets
                    .zero, // Remove default padding to allow text to fit
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 12),
              ),
              child: Text(
                resource.linkTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceListScreen extends StatefulWidget {
  const ResourceListScreen({super.key});

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current search query from ResourceData *once*.
    // Provider.of<ResourceData>(context, listen: false) is safe here as this is initState.
    _searchController = TextEditingController(
        text: Provider.of<ResourceData>(context, listen: false).searchQuery);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is called when dependencies change, including when the widget is first inserted.
    // It's a good place to react to changes in inherited widgets (like Provider).
    // Ensure the controller's text is in sync if the search query changes from outside,
    // e.g., if "Clear All Filters" button is pressed.
    final String currentSearchQuery =
        Provider.of<ResourceData>(context, listen: false).searchQuery;
    if (_searchController.text != currentSearchQuery) {
      _searchController.text = currentSearchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceData>(
      builder:
          (BuildContext context, ResourceData resourceData, Widget? child) {
        // Removed: Conditional UI for loading or error states as data is always available locally.
        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Find the Help You Need',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller:
                          _searchController, // Use the stateful controller
                      decoration: InputDecoration(
                        labelText: 'Search resources...',
                        hintText: 'e.g., anxiety, LGBTQ+, hotline',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (String value) {
                        resourceData.setSearchQuery(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              sliver: SliverToBoxAdapter(
                child: FilterAndCategorySection(resourceData: resourceData),
              ),
            ),
            SliverToBoxAdapter(
              child: ActiveFilterChips(
                  resourceData: resourceData), // Display active filters
            ),
            const SliverToBoxAdapter(
              child: Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ),
            resourceData.filteredResources.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No resources found matching your criteria.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ResourceListItem(
                          resource: resourceData.filteredResources[index],
                        );
                      },
                      childCount: resourceData.filteredResources.length,
                    ),
                  ),
          ],
        );
      },
    );
  }
}

// Define FilterAndCategorySection as a separate StatelessWidget
class FilterAndCategorySection extends StatelessWidget {
  const FilterAndCategorySection({super.key, required this.resourceData});

  final ResourceData resourceData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Filter by Category or Type:', // Updated label for combined dropdown
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          key: ValueKey(resourceData.currentlyDisplayedCombinedFilter), // Added Key for `initialValue` updates
          initialValue: resourceData.currentlyDisplayedCombinedFilter, // Changed 'value' to 'initialValue'
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          items: resourceData.combinedFilterOptions
              .map<DropdownMenuItem<String>>((FilterOption option) {
                return DropdownMenuItem<String>(
                  value: option.value,
                  child: Text(option.display),
                );
              })
              .toList(),
          onChanged: (String? newValue) {
            resourceData.setCombinedFilterSelection(newValue);
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({super.key, required this.resourceData});

  final ResourceData resourceData;

  @override
  Widget build(BuildContext context) {
    final List<Widget> activeFilters = <Widget>[];

    if (resourceData.searchQuery.isNotEmpty) {
      activeFilters.add(
        Chip(
          label: Text('Search: "${resourceData.searchQuery}"'),
          onDeleted: () => resourceData.setSearchQuery(''),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          labelStyle:
              TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      );
    }

    if (resourceData.selectedCategoryFilter != 'All') {
      activeFilters.add(
        Chip(
          label: Text('Category: ${resourceData.selectedCategoryFilter}'),
          onDeleted: () => resourceData.setSelectedCategoryFilter('All'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          labelStyle:
              TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      );
    }

    if (resourceData.selectedFilterTag != 'All') {
      activeFilters.add(
        Chip(
          label: Text('Type: ${resourceData.selectedFilterTag}'),
          onDeleted: () => resourceData.setSelectedFilterTag('All'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          labelStyle:
              TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      );
    }

    if (activeFilters.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Active Filters:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8.0),
            Wrap(spacing: 8.0, runSpacing: 4.0, children: activeFilters),
            const SizedBox(height: 8.0),
            if (activeFilters.isNotEmpty)
              TextButton.icon(
                onPressed: resourceData.clearAllFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All Filters'),
              ),
            const SizedBox(height: 8.0),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(); // No active filters, hide the section
    }
  }
}

// Define ResourceListItem as a separate StatelessWidget
class ResourceListItem extends StatelessWidget {
  const ResourceListItem({super.key, required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Add subtle border based on filter type
        side: BorderSide(
          color: resource.filter == 'Phone'
              ? Colors.teal.shade300
              : resource.filter == 'Chat'
                  ? Colors.blue.shade300
                  : Colors.transparent,
          width: 1.0,
        ),
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<ResourceDetailScreen>(
            builder: (BuildContext context) =>
                ResourceDetailScreen(resource: resource),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha((255 * 0.1).round()),
                    child: Icon(
                      _getCategoryIcon(resource.category),
                      color: Theme.of(context).colorScheme.secondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      resource.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Display category as a Chip
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: <Widget>[
                  Chip(
                    label: Text(resource.category),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                  ),
                  if (resource.religious == true)
                    Chip(
                      avatar: const Icon(Icons.church_outlined, size: 18),
                      label: const Text('Religious'),
                      backgroundColor: Colors.brown.shade100,
                      labelStyle: TextStyle(color: Colors.brown.shade800),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                resource.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  onPressed: () => _launchURL(context, resource.linkURL),
                  icon: const Icon(Icons.link),
                  label: Text(resource.linkTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceDetailScreen extends StatelessWidget {
  const ResourceDetailScreen({super.key, required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          resource.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              resource.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                Chip(
                  label: Text(resource.category),
                  avatar: Icon(
                    _getCategoryIcon(resource.category),
                    size: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                ),
                Chip(
                  label: Text(resource.filter),
                  avatar: Icon(
                    _getCategoryIcon(resource.filter), // Reusing category icon logic for filter types
                    size: 18,
                    color: Colors.blue.shade700,
                  ),
                  backgroundColor: Colors.blue.shade100,
                  labelStyle: TextStyle(
                    color: Colors.blue.shade800,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                ),
                if (resource.religious == true)
                  Chip(
                    avatar: const Icon(Icons.church_outlined, size: 18),
                    label: const Text('Religious'),
                    backgroundColor: Colors.brown.shade100,
                    labelStyle: TextStyle(color: Colors.brown.shade800),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              resource.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            if (resource.tags != null && resource.tags!.isNotEmpty && resource.tags != 'undefined') ...<Widget>[
              const SizedBox(height: 16),
              Text(
                'Keywords:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: resource.tags!
                    .split(',')
                    .map<Widget>(
                      (String tag) => Chip(
                        label: Text(tag.trim()),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                    )
                    .toList(),
            ),
            ],
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(context, resource.linkURL),
                icon: const Icon(Icons.public),
                label: Text(resource.linkTitle),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _breatheAnimation; // Changed to nullable
  Timer? _timer;
  int _currentPhase = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
  int _secondsLeftInPhase = 0;
  bool _isBreathing = false;
  int _cyclesCompleted = 0;

  final List<String> _phases = const <String>[
    'Inhale',
    'Hold',
    'Exhale',
    'Hold',
  ];
  final List<int> _phaseDurations = const <int>[
    4,
    4,
    6,
    2,
  ]; // In seconds (e.g., 4-4-6-2 technique)

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Initial inhale duration
    );

    _breatheAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      _animationController,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _startBreathingExercise() {
    if (_isBreathing) {
      _stopBreathingExercise();
      return;
    }

    setState(() {
      _isBreathing = true;
      _currentPhase = 0;
      _cyclesCompleted = 0;
    });
    _executePhase();
  }

  void _executePhase() {
    if (!_isBreathing) {
      return;
    }

    final int duration = _phaseDurations[_currentPhase];
    _secondsLeftInPhase = duration;

    _animationController.duration = Duration(seconds: duration);

    if (_currentPhase == 0) {
      // Inhale
      _animationController.forward(from: 0.0);
      _breatheAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        _animationController,
      );
    } else if (_currentPhase == 2) {
      // Exhale
      _animationController.reverse(from: 1.0);
      _breatheAnimation = Tween<double>(begin: 1.0, end: 0.5).animate( // Corrected tween for reverse animation
        _animationController,
      );
    } else {
      // Hold phases - ensure controller is stopped and value is maintained
      _animationController.stop();
      _animationController.value = (_currentPhase == 1) ? 1.0 : 0.5; // Maintain scale based on previous phase
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsLeftInPhase > 0) {
          _secondsLeftInPhase--;
        } else {
          timer.cancel();
          _moveToNextPhase();
        }
      });
    });
  }

  void _moveToNextPhase() {
    if (!_isBreathing) {
      return;
    }

    setState(() {
      _currentPhase++;
      if (_currentPhase >= _phases.length) {
        _currentPhase = 0; // Loop back to inhale
        _cyclesCompleted++;
      }
    });
    _executePhase();
  }

  void _stopBreathingExercise() {
    _timer?.cancel();
    _animationController.stop();
    setState(() {
      _isBreathing = false;
      _currentPhase = 0;
      _secondsLeftInPhase = 0;
      _cyclesCompleted = 0;
    });
    _animationController.value = 0.5; // Reset to initial state
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Mindful Breathing Exercise',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Follow the visual guide to calm your mind and body.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _breatheAnimation ?? const AlwaysStoppedAnimation<double>(0.5), // Provide fallback animation
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _isBreathing ? (_breatheAnimation?.value ?? 0.5) : 0.75, // Safe null access
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha((255 * 0.5).round()), // FIX: Replaced withOpacity with withAlpha
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isBreathing
                                ? '${_phases[_currentPhase]}\n$_secondsLeftInPhase'
                                : 'Breathe',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                if (_isBreathing)
                  Text(
                    'Cycle: ${_cyclesCompleted + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _startBreathingExercise,
                  icon: Icon(_isBreathing ? Icons.stop : Icons.play_arrow),
                  label: Text(_isBreathing ? 'Stop Exercise' : 'Start Breathing'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Breathing Technique (4-4-6-2):',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Inhale for ${_phaseDurations[0]} seconds',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '• Hold breath for ${_phaseDurations[1]} seconds',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '• Exhale for ${_phaseDurations[2]} seconds',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '• Hold breath for ${_phaseDurations[3]} seconds',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


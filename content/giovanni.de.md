---
id: giovanni
lang: de
source_hash: b02e24161573
title: Giovanni
---

## What it is
Giovanni ist der Eigentümer aller Systeme, die in diesem Wiki beschrieben sind, und die Person, für die alles gebaut wird. Giovanni ist Notarzt im präklinischen Bereich in Brasilien (ein Arzt, der Notfälle außerhalb des Krankenhauses behandelt, zum Beispiel im Rettungswagen) und bereitet sich auf die Prüfung Goethe B2 (November 2026) und danach auf die FSP (Fachsprachprüfung, die deutsche medizinische Sprachprüfung) vor, um als Arzt in Deutschland zu arbeiten.

## Flow
trigger t1: Giovanni möchte etwas gebaut, beantwortet oder gelernt haben
decide d1: Wo ist Giovanni?
step s1: Tippt im Laptop-Terminal | [[claude-code]]
step s2: Schreibt dem dauerhaft laufenden Assistenten vom Handy | [[remote-assistant]]
step s3: Chattet auf claude.ai (Handy oder Browser) | [[claude-app]]
step s4: Claude arbeitet; Giovanni genehmigt alles Nach-außen-Gerichtete oder Unumkehrbare
step s5: Eine Korrektur oder dauerhafte Vorliebe wird ein Gedächtniseintrag | [[mem]]
product p1: Fertige Arbeit und Antworten
product p2: Regeln, die jeder künftige Chat zuerst liest | [[workflow-memory]]
trigger t2: Giovanni möchte Deutsch üben
step s6: Lernt mit den Quiz-Apps | [[quizapp]], [[quizweb]]
product p3: Lernfortschritt, den die Apps speichern
trigger t3: Giovanni fragt sich, wie die Teile zusammenpassen
step s7: Liest dieses Wiki | [[wiki]]
product p4: Eine Antwort auf die Architekturfrage

t1 -> d1
d1 -Laptop-> s1
d1 -Handy-> s2
d1 -claude.ai-> s3
s1 -> s4
s2 -> s4
s3 -> s4
s4 -> p1
s4 -> s5
s5 -> p2
t2 -> s6
s6 -> p3
t3 -> s7
s7 -> p4

## What it does
Giovanni entscheidet, was gebaut wird, und genehmigt alles, was nach außen wirkt oder nicht rückgängig zu machen ist. Korrekturen und Vorlieben, die Giovanni äußert, werden zu Einträgen im gemeinsamen Gedächtnis ([[mem]]). Giovanni lernt Deutsch mit [[quizapp]] und [[quizweb]] und liest dieses [[wiki]], um zu verstehen, wie die Teile zusammenpassen.

## How it does it
Giovanni spricht mit [[claude-code]] im Terminal des Laptops, mit dem [[remote-assistant]] vom Handy aus und mit der [[claude-app]] auf claude.ai. Dauerhafte Regeln (in der Sprache der Nachricht antworten, einfach erklären, vor Aktionen nach außen fragen) stehen in [[workflow-memory]], nicht in diesem Wiki.

## Where it sits in the pipeline
Am Anfang und am Ende jeder Arbeitskette: Giovanni ist die Quelle der Anforderungen (was gebaut werden muss) und der letzte Genehmiger. Die Entscheidung, die diese Rolle prägt, ist ADR-0003 in [[workflow-memory]] (ein ADR, „Architecture Decision Record“, ist eine kurze Notiz, die eine wichtige Entscheidung und ihre Gründe festhält).

## Who receives its output
Die Claude-Instanzen erhalten Giovannis Anweisungen; das Gedächtnissystem erhält Giovannis Korrekturen.

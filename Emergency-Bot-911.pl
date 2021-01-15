%%event: UTD Hackaton HackReason
%%Professor: Gopal Gupta
%%author: Mohsen Shoraki
%%system & language: sCasp ProLog 
%%App Description: Basic 911 AI Bot, generates set of possible answers according to caller input. 

call_911:-write('This is UTD Emergency Bot, What is the exact location of your emergency?').

%facts

know_address(jack).
not_there(jack).
reason_of_emergency(medical).
observed_flame(jack).
know_phone_number(jack).
caller_name(jack).
heard_before(jack).
other_people_at_event(yes).
scared(jack).
vehicle_noise(yes).
suspect(yes).
has_knowledge(jack).

%%predicates
%%simulate set of answer from given facts

%What is the address of the emergency?
at_address(P):- know_address(P), its_there(P).
at_address(P):- know_address(P), not_there(P).
-at_address(P):- -know_address(P), not_there(P).
know_direction(P):- -know_address(P), its_there(P).
at_address(P):- not at_address(P), know_direction(P), moving.


%What is the phone number you are calling from?

right_phone_number(P):- know_phone_number(P), at_address(P).
-right_phone_number(P):- know_phone_number(P), not at_address(P).
-right_phone_number(P):- not know_phone_number(P), at_address(P).


%What is your name?

correct_name(X):- caller_name(X), heard_before(X).
correct_name(X):- caller_name(X), spelled_by_caller(X).
-correct_name(X):- not heard_before(X).
-correct_name(X):- not spelled_by_caller(X), not heard_before(X).


%Tell me exactly what happened. Reason?

emergency_list(X,[X,T]).
emergency_list(X,[_|T]):- emergency_list(X,T).
correct_emergency_type(X):- reason_of_emergency(X), exact_issue(X).
exact_issue(X):- emergency_list(X,['fire','collapsed','terrorist','accident','fight','heart attack','medical']).
-correct_emergency_type(X):- not exact_issue(X).


%For fire calls, you may be asked the following questions
just_smoke(X):- not observed_flame(X).
observed_flame(X):- observed_flame(X).
observed_flame(X):- ask_question(['what is exactly is on fire?',
                                                      'what color is the smoke?',
                                                      'Is anyone inside the buliding?', 
                                                      'Do you know how thr fire started?',
                                                      'Are there other items near the fire that it can spread to?']).
ask_question([]).
ask_question([H|T]):- ask(H), ask_question(T).
ask(X):-write(X), nl.

%In a police situation, you may be asked the following questions?

get_suspect_description(X).
get_suspect_description(X):- other_people_at_event(X), suspect(X).
-get_suspect_description(X):- -other_people_at_event(X).
-get_suspect_description(X):- other_people_at_event(X), scared(X).
get_suspect_description(X):- not other_people_at_event(X), not scared(X), suspect(X).
get_vehicle_info(X).
get_vehicle_info(X):- get_suspect_description(X), vehicle_noise(X).
get_vehicle_info(X):- vehicle_noise(X).

%check if the caller can help?
able_to_help(X).
able_to_help(X):- has_knowledge(X), -scared(X).
able_to_help(X):- not has_knowledge(X), has_experience(X), not scared(X).
able_to_help(X):- has_knowledge(X), -has_experience(X), not scared(X).
-able_to_help(X):- -has_knowledge(X), -has_experience(X), scared(X).

%%Queries
?- at_address(P).
?- right_phone_number(P).
?- correct_name(X).
?- reason_of_emergency(X).
?- just_smoke(X).
?- observed_flame(X).
?- get_suspect_description(X).
?- able_to_help(X).

%%s(CASP):s(CASP) is a system for automating commonsense reasoning, 
%%developed by UT Dallas in conjunction with IMDEA.

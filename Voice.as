package  {
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import nape.callbacks.Callback;
	import flash.media.SoundChannel;
	
	public class Voice {
		
		static private var soundChannel:SoundChannel = null;

		[Embed(source="voice-what.mp3")] static private var voice_what : Class;
		[Embed(source="voice-did-you-know.mp3")] static private var voice_did_you_know : Class;
		[Embed(source="voice-when-you-die.mp3")] static private var voice_when_you_die : Class;
		[Embed(source="voice-that-alone.mp3")] static private var voice_that_alone : Class;
		[Embed(source="sound-didyoureally.mp3")] static private var voice_did_you_really : Class;
		[Embed(source="voice-thats-right.mp3")] static private var voice_thats_right : Class;
		[Embed(source="voice-cantwait.mp3")] static private var voice_cant_wait : Class;
		[Embed(source="voice-oh-youd-be-surprised.mp3")] static private var voice_oh_youd_be_surprised : Class;
		[Embed(source="voice-ben-look-into.mp3")] static private var voice_ben_look_into : Class;
		[Embed(source="voice-you-will-convert.mp3")] static private var voice_you_will_convert : Class;
		[Embed(source="voice-dark-side-bad.mp3")] static private var voice_dark_side_bad : Class;
		[Embed(source="voice-so-did-it-work.mp3")] static private var voice_so_did_it_work : Class;
		[Embed(source="voice-yes.mp3")] static private var voice_yes : Class;
		[Embed(source="voice-no.mp3")] static private var voice_no : Class;
		[Embed(source="voice-yes-i-knew.mp3")] static private var voice_yes_i_knew : Class;
		[Embed(source="voice-im-a-natural.mp3")] static private var voice_im_a_natural : Class;
		[Embed(source="voice-i-was-able.mp3")] static private var voice_i_was_able : Class;
		[Embed(source="voice-i-am-really-the-best.mp3")] static private var voice_i_am_really_the_best : Class;
		[Embed(source="voice-rey-there-is-someone.mp3")] static private var voice_rey_there_is_someone : Class;
		[Embed(source="voice-ouin.mp3")] static private var voice_ouin : Class;
		[Embed(source="voice-hateyoukylo.mp3")] static private var voice_hate_you_kylo : Class;
		[Embed(source="voice-rey-stop-crying.mp3")] static private var voice_rey_stop_crying : Class;
		[Embed(source="you-you-are-the-one.mp3")] static private var voice_you_you_are : Class;
		[Embed(source="you-are-mean.mp3")] static private var voice_you_are_mean : Class;
		[Embed(source="voice-over-my-dead.mp3")] static private var voice_over_my_dead_body : Class;
		[Embed(source="voice-never-id-rather.mp3")] static private var voice_never_id_rather : Class;
		[Embed(source="voice-prepare-to-die.mp3")] static private var voice_prepare_to_die : Class;
		[Embed(source="voice-ben-shut-beep.mp3")] static private var voice_ben_shut_beep : Class;
		[Embed(source="voice-ben-shut.mp3")] static private var voice_ben_shut : Class;
		[Embed(source="voice-god-damnit.mp3")] static private var voice_godamnit : Class;
		[Embed(source="voice-godmanit-beep.mp3")] static private var voice_goddamnit_beep : Class;
		[Embed(source="voice-rey-do-what-he-says.mp3")] static private var voice_rey_do_what_he_says : Class;
		[Embed(source="voice-excellent-work.mp3")] static private var voice_excellent_work : Class;
		[Embed(source="voice-you-are-not.mp3")] static private var voice_you_are_not : Class;
		[Embed(source="voice-kylo-what-is-this.mp3")] static private var voice_kylo_what_is_this: Class;
		[Embed(source="voice-could-you-at-least.mp3")] static private var voice_could_you_at_least: Class;
		[Embed(source="voice-guards.mp3")] static private var voice_guards: Class;
		[Embed(source="voice-not-so-fast.mp3")] static private var voice_not_so_fast: Class;
		[Embed(source="voice-im-kathleen.mp3")] static private var voice_im_kathleen: Class;
		[Embed(source="voice-you-werent-planning.mp3")] static private var voice_you_werent_planning: Class;
		[Embed(source="voice-hell-yes.mp3")] static private var voice_hell_yes: Class;
		[Embed(source="voice-perhaps-you-dont.mp3")]  static private var voice_perhaps_you_dont: Class;
		[Embed(source="voice-and-now.mp3")]  static private var voice_and_now: Class;
		[Embed(source="voice-dead-rey.mp3")]  static private var voice_dead_rey: Class;
		[Embed(source="voice-just-betray.mp3")]  static private var voice_just_betray: Class;
		[Embed(source="voice-that-might-also.mp3")]  static private var voice_that_might_also: Class;
		[Embed(source="voice-deus-ex.mp3")]  static private var voice_deus_ex: Class;
		[Embed(source="voice-you-made-a-wise.mp3")]  static private var voice_you_made_a_wise: Class;
		[Embed(source="voice-i-guess.mp3")] static private var voice_i_guess: Class;
		[Embed(source="voice-you-did-a-great-job.mp3")] static private var voice_you_did_a_great_job: Class;
		[Embed(source="voice-so-you-thought.mp3")] static private var voice_so_you_thought: Class;
		[Embed(source="voice-i-can-read.mp3")] static private var voice_i_can_read: Class;		
		[Embed(source="voice-just-because.mp3")] static private var voice_just_because: Class;
		[Embed(source="voice-oh-but-you-are.mp3")] static private var voice_oh_but_you_are: Class;
		[Embed(source="voice-such-poorly.mp3")] static private var voice_such_poorly: Class;
		[Embed(source="voice-kylo-we-dont-have.mp3")] static private var voice_kylo_we_dont_have: Class;
		[Embed(source="voice-can-you-please.mp3")] static private var voice_can_you_please: Class;
		[Embed(source="voice-snoke-you-imbecile.mp3")] static private var voice_snoke_you_imbecile: Class;
		[Embed(source="voice-i-just-wanted.mp3")] static private var voice_i_just_wanted: Class;
		[Embed(source="voice-what-am-i-gonna-do.mp3")] static private var voice_what_am_i_gonna_do: Class;
		[Embed(source="voice-hum-he-does-have-a-point.mp3")] static private var voice_hum_he_does_have_a_point: Class;
		[Embed(source="voice-perhaps-i-should.mp3")] static private var voice_perhaps_i_should: Class;
		[Embed(source="voice-oh-what-am-i-saying.mp3")] static private var voice_oh_what_am_i_saying: Class;
		[Embed(source="voice-i-have-to-decide.mp3")] static private var voice_i_have_to_decide: Class;
		[Embed(source="voice-i-think-id-better-listen.mp3")] static private var voice_i_think_id_better_listen: Class;
		[Embed(source="voice-ok-i-guess-kill-it-is.mp3")] static private var voice_ok_i_guess_kill_it_is: Class;
		[Embed(source="voice-who-are-you.mp3")] static private var voice_who_are_you: Class;
		[Embed(source="voice-why-not.mp3")] static private var voice_why_not: Class;
		[Embed(source="voice-you-have-a-problem.mp3")] static private var voice_you_have_a_problem: Class;
		[Embed(source="voice-hey-but-what.mp3")] static private var voice_hey_but_what: Class;
		[Embed(source="voice-i-dont-know.mp3")] static private var voice_i_dont_know: Class;
		[Embed(source="voice-cant-you-ask.mp3")] static private var voice_cant_you_ask: Class;
		[Embed(source="voice-argh-nevermind.mp3")] static private var voice_argh_nevermind: Class;
		[Embed(source="voice-looks-like.mp3")] static private var voice_looks_like: Class;
		[Embed(source="voice-i-just-wish.mp3")] static private var voice_i_just_wish: Class;
		[Embed(source="voice-alright-now.mp3")] static private var voice_alright_now: Class;
		[Embed(source="voice-right-in-front.mp3")] static private var voice_right_in_front: Class;
		[Embed(source="voice-i-cant-think.mp3")] static private var voice_i_cant_think: Class;		
		[Embed(source="voice-at-last.mp3")] static private var voice_at_last: Class;
		
		static public function getVoice(msg:String):Array {
//			trace('"'+msg.toLowerCase().substr(0,10)+'"');
			var tag = msg.toLowerCase().substr(0,10);
			switch(tag) {
				case "what?...":
					return [new voice_what,3,30];
				case "did you kn":
					return [new voice_did_you_know,2,30];
				case "... when y":
					return [new voice_when_you_die,2,37];
				case "that alone":
					return [new voice_that_alone,2,45];
				case "did you re":
					return [new voice_did_you_really,2,40];
				case "that's rig":
					return [new voice_thats_right, 2, 55];
				case "can't wait":
					return [new voice_cant_wait, 4, 35];
				case "oh, you'd ":
					return [new voice_oh_youd_be_surprised, 2, 35];
				case "ben, look ":
					return [new voice_ben_look_into, 3, 65];
				case "you will c":
					return [new voice_you_will_convert, 2, 70];
				case "dark side,":
					return [new voice_dark_side_bad, 2, 80];
				case "so... did ":
					return [new voice_so_did_it_work, 2, 40];
				case "yes.":
					return [new voice_yes, 2, 30];
				case "no.":
					return [new voice_no, 2, 30];
				case "yes! i kne":
					return [new voice_yes_i_knew, 2, 50];
				case "i'm a natu":
					return [new voice_im_a_natural, 2, 50];
				case "i was able":
					return [new voice_i_was_able, 2, 35];
				case "i am reall":
					return [new voice_i_am_really_the_best, 2, 50];
				case "rey. there":
					return [new voice_rey_there_is_someone, 3, 50];
				case "ouinnnnn..":
					return [new voice_ouin, 1.5, 70];
				case "i hate you":
					return [new voice_hate_you_kylo, 1.5, 70];
				case "rey, stop ":
					return [new voice_rey_stop_crying, 3, 60];
				case "you! you a":
					return [new voice_you_you_are, 2.5, 55];
				case "you are me":
					return [new voice_you_are_mean, 1.5, 60];
				case "over my de":
					return [new voice_over_my_dead_body, 1.5, 40];
				case "never! i'd":
					return [new voice_never_id_rather, 1.5, 60];
				case "prepare to":
					return [new voice_prepare_to_die, 1.5, 55];
				case "goddamn it":
					return [new voice_godamnit, 2, 40];
				case "ben... shu":
					var voice:Sound = ActionManager.isCensored() 
						? new voice_ben_shut_beep() : new voice_ben_shut();
					return [voice, 1.5, 40];
				case "rey, do wh":
					return [new voice_rey_do_what_he_says, 3, 55];
				case "excellent ":
					return [new voice_excellent_work, 3, 55];
				case "you are no":
					return [new voice_you_are_not, 3, 50];
				case "kylo, what":
					return [new voice_kylo_what_is_this, 3, 50];
				case "could you ":
					return [new voice_could_you_at_least, 3, 50];
				case "guards! du":
					return [new voice_guards, 3, 55];
				case "not so fas":
					return [new voice_not_so_fast, 2, 50];
				case "i'm caitli":
					return [new voice_im_kathleen, 2, 65];
				case "you weren'":
					return [new voice_you_werent_planning, 2, 60];
				case "hell yes, ":
					return [new voice_hell_yes, 2, 70];
				case "perhaps yo":
					return [new voice_perhaps_you_dont, 2, 66];
				case "and now yo":
					return [new voice_and_now, 2, 70];
				case "dead rey d":
					return [new voice_dead_rey, 2, 60];
				case "just betra":
					return [new voice_just_betray, 2, 65];
				case "that might":
					return [new voice_that_might_also, 2, 70];
				case "deus ex wh":
					return [new voice_deus_ex, 2, 60];
				case "you made a":
					return [new voice_you_made_a_wise, 2, 65];
				case "i guess sh":
					return [new voice_i_guess, 2, 60];
				case "you did a ":
					return [new voice_you_did_a_great_job, 2, 60];
				case "so, you th":
					return [new voice_so_you_thought, 2, 50];
				case "i can read":
					return [new voice_i_can_read, 2, 60];
				case "just becau":
					return [new voice_just_because, 2, 50];
				case "oh, but yo":
					return [new voice_oh_but_you_are, 2, 60];
				case "such poorl":
					return [new voice_such_poorly, 2, 60];
				case "...snoke, ":
					return [new voice_snoke_you_imbecile, 1.5, 45];
				case "...i just ":
					return [new voice_i_just_wanted, 1.5, 50];
				case "...what am":
					return [new voice_what_am_i_gonna_do, 1.5, 50];
				case "hey kylo, ":
					return [new voice_kylo_we_dont_have, 2, 60];
				case "can you pl":
					return [new voice_can_you_please, 2, 50];
				case "...hum, he":
					return [new voice_hum_he_does_have_a_point, 1.5, 50];
				case "...perhaps":
					return [new voice_perhaps_i_should, 1.5, 50];
				case "...oh what":
					return [new voice_oh_what_am_i_saying, 1.5, 52];
				case "...i have ":
					return [new voice_i_have_to_decide, 1.5, 55];
				case "... i just":
					return [new voice_i_just_wish, 1.5, 50];
				case "...i think":
					return [new voice_i_think_id_better_listen, 1, 50];
				case "...ok, i g":
					return [new voice_ok_i_guess_kill_it_is, 1, 60];
				case "who are yo":
					return [new voice_who_are_you, 2, 50];
				case "why not? i":
					return [new voice_why_not, 2, 60];
				case "you have a":
					return [new voice_you_have_a_problem, 2, 50];
				case "hey, but w":
					return [new voice_hey_but_what, 2, 50];
				case "i don't kn":
					return [new voice_i_dont_know, 2, 50];
				case "can't you ":
					return [new voice_cant_you_ask, 2, 50];
				case "argh... ne":
					return [new voice_argh_nevermind, 2, 60];
				case "...looks l":
					return [new voice_looks_like, 1.5, 50];
				case "...alright":
					return [new voice_alright_now, 1.5, 50];
				case "...right i":
					return [new voice_right_in_front, 1.5, 50];
				case "...i can't":
					return [new voice_i_cant_think, 1.5, 55];
				case "...at last":
					return [new voice_at_last, 2, 60];
				case "*beep* it,":
					return [new voice_goddamnit_beep, 2, 40];
				default:
					trace(tag);
			}
			return [null];
		}
		
		static public function process(msg:String):int {
			if(!ActionManager.hearVoice()) {
				return 0;
			}
			var soundInfo:Array = getVoice(msg);
			var sound:Sound = soundInfo[0];
			if(sound) {
				if(soundChannel !== null) {
					soundChannel.stop();
				}
				var volume = soundInfo[1] || 1;
				soundChannel = sound.play(0,0,new SoundTransform(volume));
			}
			return soundInfo[2];
		}
		
		static public function cut():void {
			if(soundChannel !== null) {
				soundChannel.stop();
				soundChannel = null;
			}
		}

	}
	
}

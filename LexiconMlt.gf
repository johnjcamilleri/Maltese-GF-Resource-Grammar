-- LexiconMlt.gf: test lexicon of 300 content words
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2011
-- Licensed under LGPL

--# -path=.:../abstract:../common:../prelude

concrete LexiconMlt of Lexicon = CatMlt **
	--open ParadigmsMlt, ResMlt, Prelude in {
	open ParadigmsMlt, IrregMlt, ResMlt in {

	flags optimize=values ; coding=utf8 ;

	lin

		{- ===== My Verbs ===== -}

		{-
		cut_V2 = mkVerb "qata'" "aqta'" "aqtgħu" ;
		write_V2 = mkVerb "kiteb" ;
		break_V2 = mkVerb "kiser" ;
		find_V2 = mkVerb "sab" ;
		throw_V2 = mkVerb "tefa'" ;
		hear_V2 = mkVerb "sama'" "isma'" "isimgħu" ;
		fear_V2 = mkVerb "beża'" ;
		pray_V = mkVerb "talab" "itlob" "itolbu" ;
		understand_V2 = mkVerb "fehem" ;
		pull_V2 = mkVerb "ġibed" ;
		walk_V = mkVerb "mexa'" ;
		-}
		-- die_V = mkVerb "miet" ;
		die_V = mkVerb "qarmeċ" ;


		{- ===== My Nouns ===== -}

		--airplane_N = mkNoun "ajruplan" Masc ;
		airplane_N = mkNoun "ajruplan" ;
		--apple_N = mkNoun "tuffieħa" Fem ;
		apple_N = mkNounColl "tuffieħ" ;

		bench_N = mkNoun "bank" "bankijiet" ;



		{- ===== Required by RGL ===== -}


--		add_V3
--		alas_Interj
--		already_Adv
		animal_N = mkNoun "annimal" ;
--		answer_V2S
		apartment_N = mkNoun "appartament" ;
		art_N = mkNounNoPlural "arti" ;
--		ashes_N = mkNoun "rmied" ;
--		ask_V2Q
		baby_N = mkNoun "tarbija" "trabi" ;
		back_N = mkNounNoPlural "dahar" ;
--		bad_A
		bank_N = mkNoun "bank" "banek" ;
		bark_N = mkNoun "qoxra" ;
--		beautiful_A
--		become_VA
		beer_N = mkNoun "birra" ;
--		beg_V2V
		belly_N = mkNoun "żaqq" ;
--		big_A
		bike_N = mkNoun "rota" ;
		bird_N = mkNoun "għasfur" ;
--		bite_V2
--		black_A
		blood_N = mkNoun "demm" ;
--		blow_V
--		blue_A
		boat_N = mkNoun "dgħajsa" "dgħajjes" ;
		bone_N = mkNoun "għadma" "għadam" ;
		book_N = mkNoun "ktieb" "kotba" ;
		boot_N = mkNoun "żarbuna" "żraben" ;
		boss_N = mkNoun "imgħallem" ;
		boy_N = mkNoun "tifel" "subien" ;
		bread_N = mkNoun "ħobż" ;
--		break_V2
		breast_N = mkNoun "sider" ;
--		breathe_V
--		broad_A
		brother_N2 = mkNoun "ħu" ;
--		brown_A
--		burn_V
		butter_N = mkNoun "butir" ;
--		buy_V2
		camera_N = mkNoun "kamera" ;
		cap_N = mkNoun "beritta" ;
		car_N = mkNoun "karozza" ;
		carpet_N = mkNoun "tapit" ;
		cat_N = mkNoun "qattus" ;
		ceiling_N = mkNoun "saqaf" ;
		chair_N = mkNoun "siġġu" ;
		cheese_N = mkNoun "ġobon" ;
		child_N = mkNoun "tfajjel" ;
		church_N = mkNoun "knisja" ;
		city_N = mkNoun "belt" ;
--		clean_A
--		clever_A
--		close_V2
		cloud_N = mkNoun "sħaba" ;
		coat_N = mkNoun "kowt" ;
--		cold_A
--		come_V
		computer_N = mkNoun "kompjuter" ;
--		correct_A
--		count_V2
		country_N = mkNoun "pajjiż" ;
		cousin_N = mkNoun "kuġin" ;
		cow_N = mkNoun "baqra" ;
--		cut_V2
		day_N = mkNoun "ġurnata" ;
--		dig_V
--		dirty_A
		distance_N3 = mkNoun "distanza" ;
--		do_V2
		doctor_N = mkNoun "tabib" ;
		dog_N = mkNoun "kelb" ;
		door_N = mkNoun "bieb" ;
--		drink_V2
--		dry_A
--		dull_A
		dust_N = mkNoun "trab" ;
		ear_N = mkNoun "widen" ;
		earth_N = mkNoun "art" ; -- dinja?
--		easy_A2V
--		eat_V2
		egg_N = mkNoun "bajda" ;
--		empty_A
		enemy_N = mkNoun "għadu" ;
		eye_N = mkNoun "għajn" ;
		factory_N = mkNoun "fabbrika" ;
--		fall_V
--		far_Adv
		fat_N = mkNoun "xaħam" ;
		father_N2 = mkNoun "missier" ;
--		fear_V2
--		fear_VS
		feather_N = mkNoun "rixa" ;
--		fight_V2
--		find_V2
		fingernail_N = mkNoun "difer" ;
		fire_N = mkNoun "nar" ;
		fish_N = mkNoun "ħuta" ;
--		float_V
		floor_N = mkNoun "art" ;
--		flow_V
		flower_N = mkNoun "fjura" ;
--		fly_V
		fog_N = mkNoun "ċpar" ;
		foot_N = mkNoun "sieq" ;
		forest_N = mkNoun "foresta" ;
--		forget_V2
--		freeze_V
		fridge_N = mkNoun "friġġ" ;
		friend_N = mkNoun "ħabib" ;
		fruit_N = mkNoun "frotta" ;
--		full_A
--		fun_AV
		garden_N = mkNoun "ġnien" ;
		girl_N = mkNoun "tifla" ;
--		give_V3
		glove_N = mkNoun "ingwanta" ;
--		go_V
		gold_N = mkNoun "deheb" ;
--		good_A
		grammar_N = mkNoun "grammatika" ;
		grass_N = mkNoun "ħaxix" ;
--		green_A
		guts_N = mkNoun "imsaren" ;
		hair_N = mkNoun "xagħar" ;
		hand_N = mkNoun "id" ;
		harbour_N = mkNoun "port" ;
		hat_N = mkNoun "kappell" ;
--		hate_V2
		head_N = mkNoun "ras" ;
--		hear_V2
		heart_N = mkNoun "qalb" ;
--		heavy_A
		hill_N = mkNoun "għolja" ;
--		hit_V2
--		hold_V2
--		hope_VS
		horn_N = mkNoun "ħorn" ;
		horse_N = mkNoun "żiemel" ;
--		hot_A
		house_N = mkNoun "dar" ;
--		hunt_V2
		husband_N = mkNoun "raġel" ;
		ice_N = mkNoun "silġ" ;
--		important_A
		industry_N = mkNoun "industrija" ;
		iron_N = mkNoun "ħadid" ;
--		john_PN
--		jump_V
--		kill_V2
		king_N = mkNoun "re" ;
		knee_N = mkNoun "irkoppa" ;
--		know_V2
--		know_VQ
--		know_VS
		lake_N = mkNoun "għadira" ;
		lamp_N = mkNoun "lampa" ;
		language_N = mkNoun "lingwa" ; -- lsien?
--		laugh_V
		leaf_N = mkNoun "werqa" ;
--		learn_V2
		leather_N = mkNoun "ġilda" ;
--		leave_V2
--		left_Ord
		leg_N = mkNoun "riġel" ; -- sieq?
--		lie_V
--		like_V2
--		listen_V2
--		live_V
		liver_N = mkNoun "fwied" ;
--		long_A
--		lose_V2
		louse_N = mkNoun "qamla" ;
		love_N = mkNoun "imħabba" ;
--		love_V2
		man_N = mkNoun "raġel" ;
--		married_A2
		meat_N = mkNoun "laħam" ;
		milk_N = mkNoun "ħalib" ;
		moon_N = mkNoun "qamar" ;
		mother_N2 = mkNoun "omm" ;
		mountain_N = mkNoun "muntanja" ;
		mouth_N = mkNoun "ħalq" ;
		music_N = mkNoun "musika" ;
		name_N = mkNoun "isem" ;
--		narrow_A
--		near_A
		neck_N = mkNoun "għonq" ;
--		new_A
		newspaper_N = mkNoun "gazzetta" ;
		night_N = mkNoun "lejl" ;
		nose_N = mkNoun "imnieħer" ;
--		now_Adv
		number_N = mkNoun "numru" ;
		oil_N = mkNoun "żejt" ;
--		old_A
--		open_V2
--		paint_V2A
		paper_N = mkNoun "karta" ;
--		paris_PN
		peace_N = mkNoun "paċi" ;
		pen_N = mkNoun "pinna" ;
		person_N = mkNoun "persuna" ;
		planet_N = mkNoun "pjaneta" ;
		plastic_N = mkNoun "plastik" ;
--		play_V
--		play_V2
		policeman_N = mkNoun "pulizija" ;
		priest_N = mkNoun "qassis" ;
--		probable_AS
--		pull_V2
--		push_V2
--		put_V2
		queen_N = mkNoun "reġina" ;
		question_N = mkNoun "mistoqsija" ; -- domanda?
		radio_N = mkNoun "radju" ;
		rain_N = mkNoun "xita" ;
--		rain_V0
--		read_V2
--		ready_A
		reason_N = mkNoun "raġuni" ;
--		red_A
		religion_N = mkNoun "reliġjon" ;
		restaurant_N = mkNoun "ristorant" ;
--		right_Ord
		river_N = mkNoun "xmara" ;
		road_N = mkNoun "triq" ;
		rock_N = mkNoun "ġebla" ;
		roof_N = mkNoun "saqaf" ;
		root_N = mkNoun "qħerq" ;
		rope_N = mkNoun "ħabel" ;
--		rotten_A
--		round_A
--		rub_V2
		rubber_N = mkNoun "gomma" ;
		rule_N = mkNoun "regola" ;
--		run_V
		salt_N = mkNoun "melħ" ;
		sand_N = mkNoun "ramel" ;
--		say_VS
		school_N = mkNoun "skola" ;
		science_N = mkNoun "sxjenza" ;
--		scratch_V2
		sea_N = mkNoun "baħar" ;
--		see_V2
		seed_N = mkNoun "żerriegħa" ;
--		seek_V2
--		sell_V3
--		send_V3
--		sew_V
--		sharp_A
		sheep_N = mkNoun "nagħaġ" ;
		ship_N = mkNoun "vapur" ;
		shirt_N = mkNoun "qmis" ;
		shoe_N = mkNoun "żarbuna" ;
		shop_N = mkNoun "ħanut" ;
--		short_A
		silver_N = mkNoun "fidda" ;
--		sing_V
		sister_N = mkNoun "oħt" ;
--		sit_V
		skin_N = mkNoun "ġilda" ;
		sky_N = mkNoun "sema" ;
--		sleep_V
--		small_A
--		smell_V
		smoke_N = mkNoun "duħħan" ;
--		smooth_A
		snake_N = mkNoun "serp" ;
		snow_N = mkNoun "borra" ;
		sock_N = mkNoun "kalzetta" ;
		song_N = mkNoun "kanzunetta" ;
--		speak_V2
--		spit_V
--		split_V2
--		squeeze_V2
--		stab_V2
--		stand_V
		star_N = mkNoun "stilla" ;
		steel_N = mkNoun "azzar" ;
		stick_N = mkNoun "lasta" ;
		stone_N = mkNoun "ġebla" ;
--		stop_V
		stove_N = mkNoun "fuklar" ;
--		straight_A
		student_N = mkNoun "student" ;
--		stupid_A
--		suck_V2
		sun_N = mkNoun "xemx" ;
--		swell_V
--		swim_V
--		switch8off_V2
--		switch8on_V2
		table_N = mkNoun "mejda" ;
		tail_N = mkNoun "denb" ;
--		talk_V3
--		teach_V2
		teacher_N = mkNoun "għalliem" ; -- għalliema ?
		television_N = mkNoun "televixin" ;
--		thick_A
--		thin_A
--		think_V
--		throw_V2
--		tie_V2
--		today_Adv
		tongue_N = mkNoun "lsien" ;
		tooth_N = mkNoun "sinna" ; -- darsa?
		train_N = mkNoun "ferrovija" ;
--		travel_V
		tree_N = mkNoun "siġra" ;
--		turn_V
--		ugly_A
--		uncertain_A
--		understand_V2
		university_N = mkNoun "università" ;
		village_N = mkNoun "raħal" ; -- villaġġ ?
--		vomit_V
--		wait_V2
--		walk_V
		war_N = mkNoun "gwerra" ;
--		warm_A
--		wash_V2
--		watch_V2
		water_N = mkNoun "ilma" ;
--		wet_A
--		white_A
--		wide_A
		wife_N = mkNoun "mara" ;
--		win_V2
		wind_N = mkNoun "riħ" ;
		window_N = mkNoun "tieqa" ;
		wine_N = mkNoun "inbid" ;
		wing_N = mkNoun "ġewnaħ" ;
--		wipe_V2
		woman_N = mkNoun "mara" ;
--		wonder_VQ
		wood_N = mkNoun "injam" ;
		worm_N = mkNoun "dudu" ; -- duda
--		write_V2
		year_N = mkNoun "sena" ;
--		yellow_A
--		young_A

} ;

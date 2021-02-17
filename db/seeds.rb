# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'open-uri'

# these contain the code to attach simple placeholders to the users and plants

# def attach_avatar(user)
#   file = File.open('app/assets/images/user-icon.png')
#   user.photo.attach(io: file, filename: 'blank-avatar.png', content_type: 'image/png')
# end

# def attach_plant_icon(user)
#   file = File.open('app/assets/images/plant-icon.jpeg')
#   user.photo.attach(io: file, filename: 'plant-icon.jpeg', content_type: 'image/jpeg')
# end

def compute_rental_status(rental)
  start_date = (rental.start_date.to_date - Date.new(2001)).to_i
  end_date = (rental.end_date.to_date - Date.new(2001)).to_i
  current_date = (DateTime.now.to_date - Date.new(2001)).to_i
  if current_date <= start_date
    return "Booking"
  elsif current_date >= end_date
    return "Completed"
  else
    return "Active"
  end
end

def compute_status(plant)
end

planturlarray = []

userurlarray = []

144.times do
  planturlarray << 'https://source.unsplash.com/collection/5051863'
end

66.times do
  planturlarray << 'https://source.unsplash.com/collection/9440634'
end

18.times do
  planturlarray << 'https://source.unsplash.com/collection/69704724'
end

36.times do
  planturlarray << 'https://source.unsplash.com/collection/343175'
end

20.times do
  planturlarray << 'https://source.unsplash.com/collection/425966'
end

11.times do
  planturlarray << 'https://source.unsplash.com/collection/2385516'
end

def attach_plant_icon(plant, array)
  planturl = array[rand(0..294)]
  file = URI.open(planturl)
  plant.photo.attach(io: file, filename: 'plant-icon.jpeg', content_type: 'image/jpeg')
end

144.times do
  userurlarray << 'https://source.unsplash.com/collection/895539/300x300'
end

134.times do
  userurlarray << 'https://source.unsplash.com/collection/181462/300x300'
end

26.times do
  userurlarray << 'https://source.unsplash.com/collection/1151354/300x300'
end

def attach_user_icon(user, array)
  userurl = array[rand(0..303)]
  file = URI.open(userurl)
  user.photo.attach(io: file, filename: 'user-icon.jpeg', content_type: 'image/jpeg')
end

PLANTARRAY = ["Schinopsis boqueronensis", "Athanasia microcephala", "Miconia victorinii", "Leptospermum confertum","Plagiochila discreta",
  "Aphanostephus perennis", "Tapeinidium novoguineense", "Berberis nervosa", "Cynanchum sinoracemosum", "Bryum cyclophylloides",
  "Astragalus shatuensis", "Odontochilus poilanei", "Paullinia stipularis", "Chaetanthera eurylepis", "Syringa villosa",
  "Monoon oligocarpum", "Macromitrium braunii", "Anthurium nemoricola", "Napeanthus rupicola", "Acianthera erosa", "Acacia calcicola",
  "Corybas walliae", "Ruellia colombiana", "Diospyros veillonii", "Prunus salasii", "Crotalaria kapirensis", "Rhododendron ungeonticum",
  "Ixora havilandii", "Aldama michoacana", "Frullania haematosetacea", "Allocassine laurifolia", "Hypnum homaliocaulon",
  "Crotalaria poliochlora", "Hanburia parviflora", "Xanthosoma riedelianum", "Stylosanthes recta", "Coleus stuhlmannii",
  "Mikania trichodes", "Masdevallia lucernula", "Bryum amblyphyllum", "Stylochiton maximus", "Lonicera subsessilis", "Notopleura perparva",
  "Dypsis aquatilis", "Hooveria parviflora", "Senecio trifurcifolius", "Pycnandra fastuosa", "Begonia schulziana", "Neomirandea psoralea",
  "Ardisia retroflexa", "Reldia longipedunculata", "Breynia tonkinensis", "Alchemilla jailae", "Hieracium × silsinum", "Rhus caudata",
  "Calamagrostis pusilla", "Myrcia flagellaris", "Hypericum decaisneanum", "Cyathea hirsutissima", "Chaetocarpus pearcei",
  "Peperomia daguana", "Clematis nagaensis", "Hakea recurva", "Cuphea sessilifolia", "Bauhinia longifolia", "Acacia ancistrophylla",
  "Trichlora huascarana", "Dichanthium sericeum", "Knema sericea", "Salsola glomerata", "Pulicaria pulvinata", "Erica schelpeorum",
  "Mazaea shaferi", "Epidendrum libiae", "Trillium apetalon", "Muhlenbergia tenella", "Globba muluensis", "Macromitrium sclerodictyon",
  "Disa brevicornis", "Odontarrhena fedtschenkoana", "Isopterygium jamesii", "Verbascum pterocalycinum", "Dianthus freynii",
  "Tulipa heteropetala", "Pleurothallis eumecocaulon", "Psychotria brachyanthema", "Hedychium macrorrhizum", "Amomum bicornutum",
  "Picea koyamae", "Matthiola incana", "Amphilophium nunezii", "Lithocarpus jordanae", "Rhynchosia komatiensis", "Croton rutilus",
  "Nardus stricta", "Monimia rotundifolia", "Orixa japonica", "Paepalanthus chaseae", "Leucelene serotina", "Acer amboyense",
  "Diospyros derdo", "Crossandra puberula", "Campylotropis meeboldii", "Euphorbia pilosissima", "Euphorbia fischeri", "Oncidium auroincarum",
  "Draba longisquamosa", "Ipomoea peteri", "Ixora stenura", "Astragalus coltonii", "Zyrphelis glabra", "Urbanodendron verrucosum",
  "Marsdenia vieillardi", "Amaryllis condemaita", "Cobaea paneroi", "Diplasia karatifolia", "Jacksonia forrestii", "Carex alata",
  "Lasiopetalum glutiuosum", "Monteverdia microcarpa","Cupaniopsis concolor", "Aldama michoacana", "Sicydium davilae", "Bulbophyllum exiguum",
  "Acer yui", "Polypogon maritimus", "Cassia luerssenii", "Trepocarpus aethusae", "Discocalyx philippinensis", "Mesembryanthemum holense",
  "Thelypteris tylodes", "Triglochin hexagona", "Erica flexistyla", "Cousinia serratuloides", "Sobralia malmquistiana", "Elymus interruptus",
  "Frullania borneensis", "Glossostelma brevilobum", "Actaea heracleifolia", "Silene apetala", "Entosthodon dixonii", "Zieria robusta",
  "Cyphostemma omburense", "Megalastrum grande", "Psephellus alexeenkoi", "Froesiochloa boutelouoides", "Rhynchospora heterolepis",
  "Wettinia lanata", "Pyrethrum decaisneanum", "Impatiens platypetala", "Psychotria ankarensis", "Nepenthes micramphora", "Silene chubutensis",
  "Sisyrinchium pendulum", "Bulbophyllum nasutum", "Ceropegia ambovombensis", "Porothamnium sparsiflorum", "Pultenaea indira",
  "Bolusiella fractiflexa", "Psychotria uberabana", "Albizia salomonensis", "Eupatorium pentaflorum", "Lagrezia suessengutbii",
  "Gongora rufescens", "Myristica tenuivenia", "Taraxacum dasypogonum", "Loxostigma cavaleriei", "Polypodium munchii", "Prunus cornuta",
  "Impatiens dicentra", "Trillium catesbaei", "Steirodiscus linearilobus", "Magnolia baillonii", "Aster luengoi", "Eria aurantia",
  "Grevillea manglesii", "Pandanus forsteri", "Mortoniodendron pentagonum", "Lonchocarpus sanctae-marthae", "Lithomyrtus kakaduensis",
  "Argemone superba", "Kurzia abietinella", "Neoalsomitra balansae", "Andira spectabilis", "Wahlenbergia calcarea", "Leandra breviflora",
  "Rabiea jamesii", "Epidendrum brachystelestachyum", "Polypsecadium harmsianum", "Echinocoryne holosericea", "Bartramia pendula",
  "Melhania ovata", "Prosthechea baculus", "Deprea zakii", "Scilla pneumonanthe", "Ruellia exilis", "Asparagus albus", "Calceolaria oxyphylla",
  "Rhipidocladum panamense", "Hieracium kaeserianum", "Chenopodium nutans", "Rinorea umbricola", "Bunchosia montana",
  "Plagiobothrys magellanicus", "Carlina frigida", "Aspalathus modesta", "Astragalus longipetalus", "Bifora testiculata",
  "Benstonea rostellata", "Sherbournia buntingii", "Paepalanthus plantaginoides", "Androsace hohxilensis", "Aegiphila aracaensis",
  "Brachionidium jesupiae", "Diplycosia rupicola", "Chaenostoma debile", "Cyrtandra pedicellata", "Bulbophyllum atropurpureum",
  "Croton rutilus", "Croton rhodotrichus", "Aeonium goochiae", "Jasminum schimperi", "Chlorophytum malabaricum", "Eleocharis acutangula",
  "Pleurochaete malacophylla", "Blakea mcphersonii", "Aulax pallasia", "Anthurium rodvasquezii", "Gymnosteris parvula", "Thelymitra petrophila",
  "Centaurea giardinae", "Impatiens platypetala", "Begonia guaniana", "Camissonia dominguez-escalantorum", "Pavetta ruwenzoriensis",
  "Prasophyllum fosteri", "Berberis agricola", "Triceratella drummondii", "Jatropha seineri", "Psychotria gundlachii",
  "Ornithogalum nallihanense", "Arachniodes × respiciens", "Chloris cucullata", "Lejeunea jungneri", "Mangifera sumbawaensis",
  "Eucalyptus burdettiana", "Solms-laubachia prolifera", "Rhopalocarpus similis", "Ilex pernyi", "Onosma fistulosum", "Echinacea simulata",
  "Sorbus helenae", "Selago neglecta", "Euphorbia grammata", "Colea alata", "Aegiphila elongata", "Dicliptera vollesenii",
  "Erythrina macrophylla", "Bryum pallescens", "Sphaeropteris sibuyanensis", "Corydalis filicina", "Trichomanes diversifrons",
  "Pinguicula jackii", "Dipcadi maharashtrense", "Geophila emarginata", "Celtis peracuminata", "Gagea granulosa", "Erysimum macropetalum",
  "Gentianella albanica", "Allium oreotadzhikorum", "Leandra reitzii", "Thuidium lonchopyxis", "Thelypteris moseleyi", "Restrepia sanguinea",
  "Beilschmiedia wangii", "Boehmeria ramiflora", "Hieracium irazuense", "Castanopsis crassifolia", "Hedycarya basaltica", "Elymus smithii",
  "Drosera marchantii", "Artabotrys dielsianus", "Pyracantha koidzumii", "Elaphoglossum heteroglossum", "Rauwolfia ternifolia",
  "Cistus × stenophyllus", "Calceolaria flavovirens", "Gravesia reticulata", "Acer dureli", "Dionycha boinensis", "Ficus elasticoides",
  "Elaphoglossum litanum", "Heliotropium pterocarpum", "Arnebia fimbriata", "Sempervivum dolomiticum", "Withania riebeckii",
  "Dicliptera vollesenii", "Castanopsis borneensis", "Roldana gilgii", "Cyphostemma omburense", "Etlingera aculeatissima", "Primulina leprosa",
  "Goniothalamus copelandii", "Iris arenaria", "Scrophularia catariifolia", "Dactylocladus stenostachys", "Gouinia latifolia", "Arundo reperta",
  "Taraxacum epacroides", "Thomasia macrocarpa", "Hieracium cheirifolium", "Cousinia pycnocephala", "Deinbollia macrocarpa",
  "Alchemilla kolaensis", "Distichium austroinclinatum", "Cyperus behboudii", "Dendrophorbium lucidum", "Croton microtiglium",
  "Thrixspermum elmeri", "Galium fuegianum", "Stipa jaquemontii", "Botrychium ascendens", "Renanthera breviflora", "Gynoxys visoensis",
  "Disperis micrantha", "Leptospermum wooroonooran", "Huperzia subintegra", "Rubus atrichantherus", "Sicyos molokaiensis",
  "Schoenoplectiella naikiana", "Aspalathus pilantha", "Dendrochilum pandurichilum", "Trichostephanus gabonensis", "Astragalus vepres",
  "Kigelia lutea", "Eragrostis sabulosa", "Cirsium crassum", "Croton thoii", "Austrobuxus cracens", "Polystichum × sarukurense",
  "Ardisia basilanensis", "Argyreia luzonensis", "Tarenaya longipes", "Polysphaeria parvifolia", "Thalictrum hazaricum", "Eria lanigera",
  "Huberantha decora", "Melampodium tenellum", "Corydalis shennongensis", "Peperomia gayi", "Rinorea oppositifolia", "Ophiorrhiza amoena",
  "Gagea goekyigitii", "Crassothonna cacalioides", "Globulariopsis tephrodes", "Hoya oreostemma", "Senegalia piauhiensis", "Spigelia scabrella",
  "Plectorrhiza tridentata", "Sabatia quadrangula","Schoenus rodwayanus", "Amphithalea schlecteri", "Siphocampylus paramicola",
  "Smitinandia micrantha", "Heliophila africana", "Psychotria kitsonii", "Axinaea disrupta", "Stipa × kamelinii", "Lasianthus kilimandscharicus",
  "Artabotrys insignis", "Stylosanthes recta", "Neckera distans", "Manulea tomentosa", "Rubus buhnensis", "Philadelphus mearnsii",
  "Euphrasia flabellata", "Eriocaulon perplexum", "Cyperus rupestris", "Pilea grandifolia", "Raveniopsis tomentosa", "Bulbophyllum blepharochilun",
  "Trichodesma longipedicellatum", "Senecio planiflorus", "Metzgeria assamica", "Verbesina cymbipalea", "Voacanga bracteata", "Pouteria egregia",
  "Diplazium bostockii", "Silene skorpilii", "Acaulon leucochaete", "Grusonia robertsii", "Stenospermation arborescens", "Toxocarpus ellipticus",
  "Phragmipedium guianense", "Xanthosoma riedelianum", "Buchnera dundensis", "Orthotrichum rivulare", "Dysoxylum macranthum",
  "Taxillus rhododendricolius", "Hieracium platysemum", "Schoenoplectiella proxima", "Vernonia vulturina", "Sabal leei",
  "Bulbophyllum gongshanense", "Cupaniopsis concolor", "Sloanea mexicana", "Ditrichum brevirostre", "Pitcairnia macbridei", "Oncidium roseoides",
  "Thelypteris tylodes", "Ditrichum glaciale", "Allomarkgrafia brenesiana", "Stenostephanus lobeliiformis", "Merostachys rodonensis",
  "Meyna pubescens", "Acacia simmonsiana", "Baccharis haitiensis", "Hieracium cordatum", "Borzicactus leonensis", "Dioon tomasellii",
  "Mittenothamnium plinthophilum", "Anthurium lancea", "Achnatherum arnowiae", "Chilocarpus rostratus", "Calochortus minimus",
  "Plectranthus ombrophilus", "Urophyllum endertii", "Disperis thomensis", "Cordiera macrophylla", "Rhabdodendron gardnerianum",
  "Eriocoma webberi", "Strobilanthes hookeri", "Triraphis schinzii", "Alistilus magnificus", "Palicourea otongensis", "Torenia silvicola",
  "Geissorhiza altimontana", "Drosanthemum pulchellum", "Canarium merrillii", "Corybas karoensis", "Hydrocotyle hitchcockii",
  "Pseudosedum karatavicum", "Vernonia orchidorrhiza", "Sphaeropteris integra", "Croton atrostellatus", "Fagopyrum gracilipes",
  "Calycera pulvinata", "Hypobathrum salicinum", "Corsinia weddelli", "Blechnum societatum", "Leptomeria dielsiana", "Tristemonanthus nigrisilvae",
  "Paepalanthus lombensis", "Commelina giorgii", "Rondeletia rugelii", "Antennaria jamesonii", "Stephanbeckia plumosa", "Bernardia yucatanensis",
  "Callisthene dryadum", "Palaquium canalicultum", "Lejeunea caviloba", "Discocalyx pygmaea", "Chiloscyphus christophersenii", "Swertia handeliana",
  "Angelica ubadakensis", "Cienfuegosia drummondii", "Aizoon rehmannii", "Gardinia veolacea", "Gaertnera raphaelii", "Nepeta wuana",
  "Eulobus crassifolius", "Scutellaria luteocaerulea", "Desmodium prehensile", "Hieracium latificum", "Rhinephyllum schonlandii",
  "Berkheya pauciflora", "Calochortus kennedyi", "Scorzonera dzawakhetica", "Sacoila squamulosa", "Bulbophyllum kirroanthum"]

def get_species
  randint = rand (0..PLANTARRAY.count)
  return PLANTARRAY[randint]
end

def date_array(start_date, number, repnum)
  resultarray = []
  division = repnum / number
  datetracker = start_date.dup
  number.times do
    midarray = []
    finaldiv = division * rand(0.6..1.4)
    datetracker -= finaldiv
    if datetracker > 0
      diceroll = true if rand(0..4) >= 2.5
      diceroll ? daybreak = (Math.sqrt(rand(0..10000))).round(0) : daybreak = 0
      midarray << start_date
      start_date += finaldiv
      start_date += daybreak
      midarray << start_date
      resultarray << midarray
    end
  end
  return resultarray
end

def user_protocol(user, planturlarray)
  rand(3..7).times do
    pricingnum = rand(1.00..50.00)
    plant = Plant.new(
      species: get_species,
      status: "INSERT_STATUS",
      pricing: sprintf('%.2f', pricingnum.round(2)),
      user: user
    )
    attach_plant_icon(plant, planturlarray)
    plant.save!
    repnum = (DateTime.now.to_date - user.remember_created_at.to_date).to_f
    absnum = (DateTime.now.to_date - (Faker::Date.between(from: '2018-09-23', to: '2018-09-23')).to_date).to_f
    randomn = (rand(0..7) * Math.sqrt((repnum / absnum))).round(0)
    darray = date_array(user.remember_created_at.to_date, randomn, repnum)
    until darray == []
      datechip = darray.delete_at(0)
      rental = Rental.new(
        cost: sprintf('%.2f', ((datechip[1] - datechip[0]).to_i*plant.pricing).round(2)),
        start_date: datechip[0],
        end_date:  datechip[1],
        user: User.find(rand(1..User.all.count)),
        plant: plant
      )
      rental.status = compute_rental_status(rental)
      rental.save!
    end
  end
end

def create_admins(array, planturlarray)
  array.each do |name|
    admin = User.new(
      name: name,
      password: "tester",
      email: "#{name}@test.com",
      remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s)
    )
    file = File.open('app/assets/images/admin-icon.png')
    admin.photo.attach(io: file, filename: 'admin-icon.jpeg', content_type: 'image/jpeg')
    admin.save!
    user_protocol(admin, planturlarray)
  end
end

create_admins(["tristan", "charles", "benjamin", "pierre"], planturlarray)

45.times do
  user = User.new(
    name: Faker::Artist.name,
    password: Faker::Internet.password,
    remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s)
    )
  user.email = Faker::Internet.email(name: user.name)
  attach_user_icon(user, userurlarray)
  user.save!
end

15.times do
  user = User.new(
    name: Faker::GreekPhilosophers.name,
    password: Faker::Internet.password,
    remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s)
    )
  user.email = Faker::Internet.email(name: user.name)
  attach_user_icon(user, userurlarray)
  user.save!
  user_protocol(user, planturlarray)
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'open-uri'
require 'nokogiri'

# these contain the code to attach simple placeholders to the users and plants

# def attach_avatar(user)
#   file = File.open('app/assets/images/user-icon.png')
#   user.photo.attach(io: file, filename: 'blank-avatar.png', content_type: 'image/png')
# end

# def attach_plant_icon(user)
#   file = File.open('app/assets/images/plant-icon.jpeg')
#   user.photo.attach(io: file, filename: 'plant-icon.jpeg', content_type: 'image/jpeg')
# end

puts "destroying data..."

Rental.destroy_all
Plant.destroy_all
User.destroy_all

puts "data destroyed"

def compute_rental_status(rental)
  start_date = (rental.start_date.to_date - Date.new(2001)).to_i
  end_date = (rental.end_date.to_date - Date.new(2001)).to_i
  current_date = (DateTime.now.to_date - Date.new(2001)).to_i
  return "Booking" if current_date < start_date
  return "Completed"if current_date > end_date
  return "Active"
end

def compute_plant_status(plant)
  return "Available" if plant.rentals == []
  current_date = (DateTime.now.to_date - Date.new(2001)).to_i
  tracker = true
  plant.rentals.each do |rental|
    start_date = (rental.start_date.to_date - Date.new(2001)).to_i
    end_date = (rental.end_date.to_date - Date.new(2001)).to_i
    tracker = false unless current_date > end_date || current_date < start_date
  end
  return "Available" if tracker == true
  return "Currently unavailable"
end

puts "creating data ..."

userurlarray = []

puts "preparing data"

usernum = 0

plantarray = [["Berry catchfly", "https://bs.floristic.org/image/o/93bde3663bfe557757802d236931b446f2a31c7d"],
 ["Sulphur cinquefoil", "https://bs.floristic.org/image/o/6f0739fe3e1ad539c819f3da6646142fb56e0df9"],
 ["Bristly hawksbeard", "https://bs.floristic.org/image/o/4a0c2da151e8ae9384e0e222e8f119f8601ed575"],
 ["Montpellier maple", "https://bs.floristic.org/image/o/ae3d14b8653ca9ec8d8c408256df98196ec9d136"],
 ["Yellow bugle", "https://bs.floristic.org/image/o/6f1bbab431f34bb68841d5a3cb16fd07e569d9cf"],
 ["Rough cocklebur", "https://bs.floristic.org/image/o/6b632351c1bb4a398caa09c0343990460d0894b5"],
 ["Spiked woodrush", "https://bs.floristic.org/image/o/244d37ae60ced7b00ccac380b6435eb5aa60ce50"],
 ["Late spider-orchid", "https://bs.floristic.org/image/o/3fe4396f07a2957206f86bfe183def0b1841bad0"],
 ["Horse mint", "https://bs.floristic.org/image/o/f6e63979bfc2c97ff320487af8e0329d587dc7e0"],
 ["St. bernard’s lily", "https://bs.floristic.org/image/o/9b49378497622e1ca3ec1aabca7f8dd1f3cdae33"],
 ["Greater spearwort", "https://bs.floristic.org/image/o/3fa5430985ff18c7f08877836c6be328c5043f87"],
 ["Alpine rose", "https://bs.floristic.org/image/o/3894b3cacd2c46acd31ecf93187983b36ad080fa"],
 ["European hackberry", "https://bs.floristic.org/image/o/3b9fcdb744b4ea4c1963e961b6261723c9bd1c36"],
 ["Marvel of peru", "https://bs.floristic.org/image/o/062d991f811dbb2cb5d298c96c8f8b36dddb466e"],
 ["Sweetpotato", "https://bs.floristic.org/image/o/794d8f7f493d2502533b034a506d2bcb16a91c8e"],
 ["Horseradish", "https://bs.floristic.org/image/o/5519bc6c812819d12f1b614e88c42c0aab1fccf7"],
 ["Seawrack", "https://bs.floristic.org/image/o/05e7e3c71ba6dcbca14d447f2e3614e1b9c98e17"],
 ["Highland rush", "https://bs.floristic.org/image/o/729958ec233e228eaf712b9c2e99b1f0a7aa4ab2"],
 ["Alpine cinquefoil", "https://bs.floristic.org/image/o/11e351846b78aa20423d11ccfd76a7a9c374e9af"],
 ["Long pricklyhead poppy", "https://bs.floristic.org/image/o/1a3138a874ece7599c227e253b9eb6a237ad963a"],
 ["Stemless thistle", "https://bs.floristic.org/image/o/7b51137ce193007a42f3af4bdb9dcab1148c237a"],
 ["Small pondweed", "https://bs.floristic.org/image/o/27fef5e1062ff12986b3fd0283403d451188b523"],
 ["Shining geranium", "https://bs.floristic.org/image/o/6aafed9d691ebe8e007c5b436dbabf1d03d5e609"],
 ["Winged greenweed", "https://bs.floristic.org/image/o/93c139dc51ebc9dfc55b56d356133e4ce8b02535"],
 ["Oval-leaf knotweed", "https://d2seqvvyy3b8p2.cloudfront.net/6bdc726fdb49c908101a6170c668ee34.jpg"],
 ["Garden lettuce", "https://bs.floristic.org/image/o/7ee395463413655228bdb83cc086dd662d2b633c"],
 ["Alpine rockcress", "https://bs.floristic.org/image/o/d07406a8eb178830a8935ee1d9b73af7337aa94a"],
 ["Thinleaf false brome", "https://bs.floristic.org/image/o/6c4b95fb592e33b222f1bd4564f98ceefbbf9a85"],
 ["Knotted pearlwort", "https://bs.floristic.org/image/o/21ca982e3bd325e6bb025543d345639fb4289bba"],
 ["Single delight", "https://bs.floristic.org/image/o/4691124c07d6d850ccfea034c4666911e5c3b0c1"],
 ["Alpine saw-wort", "https://bs.floristic.org/image/o/110e2a833c30848fc44fb7d111fe7b25166d3ef6"],
 ["False yellowhead", "https://bs.floristic.org/image/o/7e3d8d702bf6e28f3dde910aed6795b7f0fc7497"],
 ["White false hellebore", "https://bs.floristic.org/image/o/62b749bbc89d2c885001a00887dbad07aaf3c291"],
 ["Violet limodore", "https://bs.floristic.org/image/o/10e60d6365696ec9c90d2bd763725fe03fa3676b"],
 ["Boehmer's cat's-tail", "https://bs.floristic.org/image/o/000f7c73aaabf731181f6ebd99dfb5702f04b8df"],
 ["Good king henry", "https://bs.floristic.org/image/o/ec7f62e30e12e1a452bb0e756b141900ddc1b23e"],
 ["Sweet-amber", "https://bs.floristic.org/image/o/5399c5315a09857f7d2e97035b1bf720aabda455"],
 ["Common balm", "https://bs.floristic.org/image/o/f3c8cbb5efaae8b5cf1c4f62880bd1b332624c09"],
 ["New zealand broadleaf", "https://bs.floristic.org/image/o/33ac003784a5877bde7e84c7bb4a42d152388816"],
 ["Common hawkweed", "https://bs.floristic.org/image/o/7959220345b65af363fae6904ed18b25563a7033"],
 ["Copse-bindweed", "https://bs.floristic.org/image/o/eb3a4605b0f27d40a98eda37be68651dcc708bdf"],
 ["Alpine sedge", "https://bs.floristic.org/image/o/f83bd4b178e094ea62dc770fd2b06fd887f09b6e"],
 ["Creeping sedge", "https://d2seqvvyy3b8p2.cloudfront.net/6ce8f0df8cdfe8105d6557709de90564.jpg"],
 ["Clustered fescue", "https://bs.floristic.org/image/o/51aa2c6dad517233b1cd98b35307f4924c173a8e"],
 ["Heart-leaved globe daisy", "https://bs.floristic.org/image/o/a255388a76b9a524c87859d2ee311d7b0ad9a124"],
 ["Starry saxifrage", "https://bs.floristic.org/image/o/923431697c101559ef784731e4a2205fb4d9e681"],
 ["Virginia pepperweed", "https://bs.floristic.org/image/o/375b336f960b265b8376fc2a2a37adcaf8470c3d"],
 ["Sand ryegrass", "https://bs.floristic.org/image/o/d3204c036a6bfaea31b54a7b3ed67f0227d38210"],
 ["Green alder", "https://bs.floristic.org/image/o/9d288a33a6229a5bd8726f8d350be21fe47a762e"],
 ["Gray field speedwell", "https://bs.floristic.org/image/o/9d5978a3913b44db235286bd4d0e229129368af6"],
 ["White mullein", "https://bs.floristic.org/image/o/f494b3b819b96559d93293b6c6cac872028c3abe"],
 ["Indian strawberry", "https://bs.floristic.org/image/o/376a1744fe8b6b92da0cb05545bc4ee81ef43aca"],
 ["Fringed pink", "https://bs.floristic.org/image/o/895df4c8c3d054d17bf6cf2128c42c3cbd5c3078"],
 ["Common houseleek", "https://bs.floristic.org/image/o/1e56f7735cbd430061d773d0aa31de69701984b9"],
 ["Plicate sweet grass", "https://bs.floristic.org/image/o/55862fedc53ebca1021c1cf2eef7ac5cbb772d0d"],
 ["Snow grass", "https://d2seqvvyy3b8p2.cloudfront.net/7e2ea5e5f4cb3511dad6eee7808aa030.jpg"],
 ["Alpine campion", "https://bs.floristic.org/image/o/c8ec81782ab533bbb8f969abd1486756b25cf9cc"],
 ["Coast sand-spurrey", "https://bs.floristic.org/image/o/96ad42b720b6084867f2f5fb2b430a32ea8e5a19"],
 ["Corn gromwell", "https://bs.floristic.org/image/o/8cff1904ed17765a311e65cb6035285cb9c93b3e"],
 ["Alpine lady's mantle", "https://bs.floristic.org/image/o/d70411a1743ccafe378f522aed5ea74a312f7391"],
 ["Seaside chamomile", "https://bs.floristic.org/image/o/cd60c26f56f5c6ebf2c04527738bc5a1b6d5d4e7"],
 ["Hooked bristlegrass", "https://bs.floristic.org/image/o/3e37b20613118b4679e71138076120eca9b12881"],
 ["Fir clubmoss", "https://bs.floristic.org/image/o/89d1d65a45a5cfb1c856a8da160e9e1ffd7d4887"],
 ["Bluntflower rush", "https://bs.floristic.org/image/o/ac8368e5de276a26a40c2be52981e4c5cd46d359"],
 ["Bird-eye primrose", "https://bs.floristic.org/image/o/fbe597eb15651f2c6300716225025a25ad62f0e5"],
 ["Alternateflower watermilfoil", "https://bs.floristic.org/image/o/ab1a0be7e1c20fa83b31ba183776856a79e01249"],
 ["Greater bladderwort", "https://bs.floristic.org/image/o/e5962c3e11b870f7dd6f1afe143be62be07a3f3b"],
 ["Twining glycine", "https://d2seqvvyy3b8p2.cloudfront.net/8698c6d477bd38ae6dfdc0699d16a2dc.jpg"],
 ["False olive", "https://bs.floristic.org/image/o/3da0d1db8cb597252ef8b9ae5742eb52336040c8"],
 ["Little cottonrose", "https://bs.floristic.org/image/o/5d851dc5cf7fd3aec23111383fa1194f4639fae9"],
 ["European searocket", "https://bs.floristic.org/image/o/dafd881eb805ee2d018a847377717e75d1bbd9ac"],
 ["Lesser swinecress", "https://bs.floristic.org/image/o/b9e696d07f125008bf04492d73f3260b49f101e5"],
 ["Giant reed", "https://bs.floristic.org/image/o/9d2084227c082eadc1cba4f4c3930a0f7114e2aa"],
 ["Bermuda buttercup", "https://bs.floristic.org/image/o/f7dc46f9a68c371720aa4ffd804df6b74309c191"],
 ["Greater masterwort", "https://bs.floristic.org/image/o/d2d53af58b2e650205136defe09746ce503a7108"],
 ["Spring fumewort", "https://bs.floristic.org/image/o/d3bc132300b17e0e518564b485194824e8c53a83"],
 ["Serrated tussock", "https://bs.floristic.org/image/o/f63b53544c45fdacb5b1e8f56fd2c20f0c0a5374"],
 ["Argentine fleabane", "https://bs.floristic.org/image/o/8d6ce0caf4c62cdadf33fd32af8622ec4b65c444"],
 ["Needle spikerush", "https://bs.floristic.org/image/o/dd62086536339190074a5d1f347c7f7106b46a9e"],
 ["White rock-rose", "https://bs.floristic.org/image/o/92747ef8f9049c907e3c04e0e36cff942a4d203b"],
 ["Broadleaf sermountain", "https://bs.floristic.org/image/o/8cf1888fc729b0c5881993f8eb392c084d1a76ca"],
 ["Opium poppy", "https://bs.floristic.org/image/o/8f0532dc9b04292a2314afd46143c78267c41f7e"],
 ["Lesser twayblade", "https://bs.floristic.org/image/o/4adb547918f8082ba61ca1fb81f54f42ee28135c"],
 ["Mountain sedge", "https://bs.floristic.org/image/o/0cc0708509609f35085df4a5cf9989939332b4b8"],
 ["Water-dropwort", "https://bs.floristic.org/image/o/1f6e8dd6f08e105d9d0647ed2e7170de585bc6f0"],
 ["Bastard balm", "https://bs.floristic.org/image/o/84e9ba45db1aaf795b0d849d70ee3a90453a34fa"],
 ["Tower mustard", "https://bs.floristic.org/image/o/4c0254bca660f1a74b6c0130158d438b758926e7"],
 ["Purple mountain saxifrage", "https://bs.floristic.org/image/o/76048419d566cf867e8ea06ac106bb86129c3b80"],
 ["Brome fescue", "https://bs.floristic.org/image/o/1252a6271a9d046393068a03d646105757f32fb1"],
 ["Monkshood", "https://bs.floristic.org/image/o/83a6225bb76c3a173bd62fb26b570f21f32e0ae0"],
 ["White water crowfoot", "https://bs.floristic.org/image/o/d72cdae78b9baa8e6ca2f5ec6bd0f960e64fc9fe"],
 ["Soft shield-fern", "https://bs.floristic.org/image/o/5eb4b4f9bca5bdc70dcbdff249011752bcbc6fd3"],
 ["Hairy buttercup", "https://bs.floristic.org/image/o/df058fe6041ea202e49b9044e3a6e8b3264fe6ee"],
 ["California poppy", "https://bs.floristic.org/image/o/f5334c840841ddfd651cbe447cccf3800830fa5d"],
 ["Deptford pink", "https://bs.floristic.org/image/o/313fb58c08dfa4e6e825e9b0578f153caaf035d7"],
 ["Gypsyflower", "https://bs.floristic.org/image/o/d6b81ab301039b6e582f970b0d3d7da14fd21eea"],
 ["Moss campion", "https://bs.floristic.org/image/o/032fd8dd350080dc5d31f0416e762dc1eea5eb68"],
 ["Pond water-crowfoot", "https://bs.floristic.org/image/o/b797dfd56b92db0dff478f0fcef3a8a354d4e144"],
 ["Dwarf willowherb", "https://d2seqvvyy3b8p2.cloudfront.net/5041121fa5cfe0598911821e6bb1034f.jpg"],
 ["Adder-wort", "https://bs.floristic.org/image/o/03772400c523eb83970943b3d8637872b5713167"],
 ["Yellow star-of-bethlehem", "https://bs.floristic.org/image/o/d795cce81b3a25ad2d8b12af900727c6ad892371"],
 ["Dyer's plumeless saw-wort", "https://bs.floristic.org/image/o/6545b767cc5df844479f871b06822b2b3a7a8df6"],
 ["Hoary alyssum", "https://bs.floristic.org/image/o/ee2fa4f5055fce47eb4fd1ddb824ce8904e521d8"],
 ["Yellow mountain saxifrage", "https://bs.floristic.org/image/o/d29678c7ebe2c3e942dd4f2554729507e176e432"],
 ["Algerian oak", "https://bs.floristic.org/image/o/0718714bdba14b284dbf10f05e249bb7489b8467"],
 ["Starch grape hyacinth", "https://bs.floristic.org/image/o/29e996c454473384f63473b7cf59470efd483f6f"],
 ["Smooth rupturewort", "https://bs.floristic.org/image/o/5f0238ab8a0a58fb9193d68692142739b11bc84c"],
 ["Sickle-leaf hare's-ear", "https://bs.floristic.org/image/o/a807b7edbec6aabd3f8e16dabf282a46c63b6559"],
 ["Ferngrass", "https://bs.floristic.org/image/o/c252a0e7b13b8db87fa8091bd134a7242d0df0b0"],
 ["Burnt tip orchid", "https://bs.floristic.org/image/o/d02187228466ef34159a9d724321ee94bdd23493"],
 ["Oakforest woodrush", "https://bs.floristic.org/image/o/49ff87925fea29ac978f50a9cba6da03adb49963"],
 ["Feather hyacinth", "https://bs.floristic.org/image/o/8c1e7d9855c58e6c2005fa48233889aa8377c593"],
 ["Scorpion-vetch", "https://bs.floristic.org/image/o/d9a2530ee697b7c2d394cfbc4d3faa5535b81a9e"],
 ["Heath milkwort", "https://bs.floristic.org/image/o/bd91f9cd84f00dde3d3c4270bc29c8ef69f02c59"],
 ["Pale knotweed", "https://bs.floristic.org/image/o/7ccf29f731d45c0f331a5b24b50ed48b005fddef"],
 ["Lesser asparagus", "https://bs.floristic.org/image/o/a1a744eb504479a4f27dbe2b6214aa7eb2b85157"],
 ["Wild clary", "https://bs.floristic.org/image/o/de2b14a980edf775ec88f22113a9c1e7ab9c54a9"],
 ["Round-headed rampion", "https://bs.floristic.org/image/o/798da604f2f03efdba153f986b8227a66fce7520"],
 ["Clammy campion", "https://d2seqvvyy3b8p2.cloudfront.net/2a1bb53f5985141c0d3aa8ac545fe908.jpg"],
 ["Florida hopbush", "https://bs.floristic.org/image/o/186567e9fa0a9cc86dc3c9e2ec0ebe6b38312787"],
 ["Annual honesty", "https://bs.floristic.org/image/o/3c9369c4f14a0b355e5cf444da6b78bad202442d"],
 ["Yellow gentian", "https://bs.floristic.org/image/o/383d930e77dfcbd43953d23123ae98fc74509473"],
 ["Small pondweed", "https://bs.floristic.org/image/o/d15d28dd8d726de0da8ae01d677c9e7f03d68418"],
 ["Rusty-back", "https://bs.floristic.org/image/o/977fc4c59c9639c96534a3ca735c1ee17462bc46"],
 ["Reflexed stonecrop", "https://bs.floristic.org/image/o/fa5f8432638d036805ef6c6baa11a8c8080e3ece"],
 ["Common flax", "https://bs.floristic.org/image/o/be2397c25dcd41ffba0b690a29b4cb42117c4ab9"],
 ["Alpine timothy", "https://bs.floristic.org/image/o/a5c3439cb79b259d09ab05e4264e723aaaee490d"],
 ["Poison hemlock", "https://bs.floristic.org/image/o/b4f2ca535cef9103d80c1a92de81b626a1f9ea5a"],
 ["Marsh gentian", "https://bs.floristic.org/image/o/cc356206062c9bed4bc15d6b68a8741176d4c9b4"],
 ["Horehound", "https://bs.floristic.org/image/o/64ada30de380526822660fbaf48e066e016d6573"],
 ["Common evening primrose", "https://bs.floristic.org/image/o/3cd329de6120921ce7abf94a2f3f453c757a5168"],
 ["Pale madwort", "https://bs.floristic.org/image/o/f1dede7c3b01ce766268d3070490985817a8e64c"],
 ["Sickle-podded alfalfa", "https://bs.floristic.org/image/o/9a371af332137fb43668d004ec8390ae686e2c77"],
 ["Sheathed sedge", "https://bs.floristic.org/image/o/49f3f2b6f52de545750f156715e308a46f830b5b"],
 ["Orange hawkweed", "https://bs.floristic.org/image/o/8f861843683e73c73e33c8ae14a72171ba64c78e"],
 ["Cherry plum", "https://bs.floristic.org/image/o/e86827fe00747f2bfb6269159482eabb0e1c8282"],
 ["Bataua palm", "https://bs.floristic.org/image/o/f0ba4622e40b50b9094fb617144e7cf4957c7cc8"],
 ["Velvetbells", "https://bs.floristic.org/image/o/c7c797b1401991cae98849b21b41aad6024c441f"],
 ["Tubular water-dropwort", "https://bs.floristic.org/image/o/8060022f00fd5e0e27072a9b65d426c5dbf05ae0"],
 ["Meadow geranium", "https://bs.floristic.org/image/o/b34e1c02dd9c8bbb01e9db967258952f4068a5f3"],
 ["Garden asparagus", "https://bs.floristic.org/image/o/0f3634b0c737e2a8be358e4e23c6385aa38fcabb"],
 ["Changing forget-me-not", "https://bs.floristic.org/image/o/9a43582ede5c88b1531bc80e65a32c34812bbc0b"],
 ["Annual water minerslettuce", "https://bs.floristic.org/image/o/9625af64889d1079017039b66a3c7d27fcc66942"],
 ["Daffodil", "https://bs.floristic.org/image/o/9c520b43b9c493528d77a23c15d2364c7af59446"],
 ["Eightpetal mountain-avens", "https://bs.floristic.org/image/o/918aacfdfbb23e1a901fc0e7305f4ac7cc7d2180"],
 ["Broadleaved lavender", "https://bs.floristic.org/image/o/e0bff466321605b8d3c67b6507c4211ad8a2f4c1"],
 ["Cinnamonspot pondweed", "https://bs.floristic.org/image/o/f17809be1b176aab90ecb385053a01c83e226479"],
 ["Trailing st. johnswort", "https://bs.floristic.org/image/o/027db0820e9520a20edaec41ef6a272ce6388af9"],
 ["Blue aphyllanthes", "https://bs.floristic.org/image/o/3d2a33bcfbf2cb35a53bdb99a523e9ef572aecc0"],
 ["Whorled solomon's-seal", "https://bs.floristic.org/image/o/2a88deff280f622e96b7b80469bc763f83b97ac9"],
 ["Licorice milkvetch", "https://bs.floristic.org/image/o/dd78f151807de16f78cd518703b5c57944b315bc"],
 ["Pond water-starwort", "https://bs.floristic.org/image/o/b5d4c0313babf8422b13eb5f3a53d5ef8780990e"],
 ["Wood speedwell", "https://bs.floristic.org/image/o/f4ab25595d9d7d175e497be6715b67421f55186a"],
 ["Roundleaf geranium", "https://bs.floristic.org/image/o/807d80f4ac54f2801e7c8455410afc8e59bbc8d1"],
 ["Goldilocks", "https://bs.floristic.org/image/o/a0035af2b98f2f68c049c85908692fc45d07b89a"],
 ["Nodding beggartick", "https://bs.floristic.org/image/o/e1fa4273214384fd524bb7dcee467e2b657c976c"],
 ["Dwarf spurge", "https://bs.floristic.org/image/o/c533e4b8112df8d4ad917207aaea1eba14e6030d"],
 ["Spotted medick", "https://bs.floristic.org/image/o/442810510bf76e9d5d09b242ab10fbc3ef2f606b"],
 ["Little white bird's-foot", "https://bs.floristic.org/image/o/334a474a49a14e63167b29cb9a3cd4f530ac36be"],
 ["Seaberry", "https://bs.floristic.org/image/o/6c72b6cffad999126d0bdcd6ec45acb9d668e472"],
 ["Pennyroyal", "https://bs.floristic.org/image/o/34e583f93f813c4e10cbe565b0f5194bba01256e"],
 ["Dooryard dock", "https://bs.floristic.org/image/o/02c8fd1757088e6989ca4a8602e04256162decd4"],
 ["Common moonwort", "https://bs.floristic.org/image/o/3fcbc6abb0239b0df6a5eacb36bdf42e1abb72e5"],
 ["Mountain-grape", "https://bs.floristic.org/image/o/9a3022c174ceac49994b35de20632f6ca0078262"],
 ["Sweetbriar rose", "https://bs.floristic.org/image/o/1001f7c5af8e1809a519a1c95dac41b948c55a0a"],
 ["False mayweed", "https://bs.floristic.org/image/o/6dd5f5644b5ecc9cf0bc98dca8634ff0c59ea982"],
 ["Little bur-clover", "https://bs.floristic.org/image/o/ce6eec52e0f490968c3e7993a2b36c8f5a0d9213"],
 ["Cayenne pepper", "https://bs.floristic.org/image/o/77580828aea73ee908c488e2d216e15cb8b587a5"],
 ["Spurgelaurel", "https://bs.floristic.org/image/o/5b7109a59e0df1696f9d48119cb9adc6b3a6b772"],
 ["Keyflower", "https://bs.floristic.org/image/o/5ab1df7158123376a753a0beda0479a3e201a2b9"],
 ["Cypress-like sedge", "https://bs.floristic.org/image/o/7f77094c3990435f7f0b9c857f580f889daed3c4"],
 ["Korean feather reed grass", "https://d2seqvvyy3b8p2.cloudfront.net/9b84231eda44e65b16e221e1ca9f722c.jpg"],
 ["Bitter fleabane", "https://bs.floristic.org/image/o/156d1f97446ffaabd79ba56c66f429e12ef82b9d"],
 ["Seaside arrowgrass", "https://bs.floristic.org/image/o/27d0059c22af60aef8e569d84850424d4fbf3ac7"],
 ["Sea aster", "https://bs.floristic.org/image/o/1584257a88dd5f60962ac6f3289e34fab5a8fc72"],
 ["Striped toadflax", "https://bs.floristic.org/image/o/700473b9cd0824a5e28046a2ef2d1d36c6f985c2"],
 ["Greater burdock", "https://bs.floristic.org/image/o/459bc907b7b3b00a710f4d8d44b9de0e059e806d"],
 ["Creeping yellowcress", "https://bs.floristic.org/image/o/bbcf6a8a656fd914db219e241cdbcecfc16ded94"],
 ["Rugosa rose", "https://bs.floristic.org/image/o/fe957b1a87df808443782ad72c2c0ddec0729370"],
 ["Dane's blood", "https://bs.floristic.org/image/o/f967dc7839c8acbaa8bce68dbcd18e7adfbdcd43"],
 ["Royal fern", "https://bs.floristic.org/image/o/530b510f2ec8a79ef98bf30dcae43cfedf1e1be0"],
 ["Spring-vetch", "https://bs.floristic.org/image/o/09ef07dda1e4bbc48269f4b6814bd03200de8d5d"],
 ["Besom heath", "https://bs.floristic.org/image/o/974afa1adcd54dcea38b4f699a62bfe633dfed19"],
 ["Pestilence wort", "https://bs.floristic.org/image/o/73ac0211f3f3f1a5016b5e760fe75365ba800fc1"],
 ["Red bartsia", "https://d2seqvvyy3b8p2.cloudfront.net/a63eb05d010e36df900139d495c3976e.jpg"],
 ["Narrowleaf cattail", "https://bs.floristic.org/image/o/45514e0b131c3329fd2378d281525afadfda6363"],
 ["Strawberry clover", "https://bs.floristic.org/image/o/6bb960d2aa4be3b3022ef77f78370eb254a14128"],
 ["Lantana", "https://bs.floristic.org/image/o/3e223b316f056e39a2232d1baef217d6e4f711c7"],
 ["Kangaroo grass", "https://bs.floristic.org/image/o/6d61499ca83f5571b2c8a61d5c6190263404b891"],
 ["Dwarf snapdragon", "https://bs.floristic.org/image/o/f409582e8e4a97afab5a56fb5618628811488fd5"],
 ["Martagon lily", "https://bs.floristic.org/image/o/7472f2d4aab860e43c882b4fb1fae0c7f3b71043"],
 ["Bloody geranium", "https://bs.floristic.org/image/o/3d25ba7f879ffef24f5c88dbbf274b5ae3fafd61"],
 ["Common meadow-rue", "https://bs.floristic.org/image/o/4c97b471529b35c4e0d4c2402b00a793199e94dd"],
 ["Weeping alkaligrass", "https://bs.floristic.org/image/o/ffa9657e9237297efcc9335b78a55994d913d9f1"],
 ["Marsh orchid", "https://bs.floristic.org/image/o/3d007c3ca08943138b64781e8941058b09c99904"],
 ["Laurustinus", "https://bs.floristic.org/image/o/f86f765267c9619fa5b9556a8cfc3c85d636f87d"],
 ["Clusterhead", "https://bs.floristic.org/image/o/4b15efbe6ee0d02c5c37deae3016bae1664c0474"],
 ["German knotgrass", "https://bs.floristic.org/image/o/fb7be576a291d11941002b8cdd5d889c9dd4097c"],
 ["European bur-reed", "https://bs.floristic.org/image/o/4474f1265ba930bc91b2766bd50d56cad3987662"],
 ["Scandinavian small-reed", "https://d2seqvvyy3b8p2.cloudfront.net/908788058c74f8fe317753eebea69818.jpg"],
 ["Indian millet", "https://bs.floristic.org/image/o/4552f3f918fab51a0fd75fc55854a85bc7cf58f7"],
 ["Slender meadow foxtail", "https://bs.floristic.org/image/o/67db23cee7b88964f6b9b95ce667bf5626253e95"],
 ["Common sunflower", "https://bs.floristic.org/image/o/f8882205b54dee7e0522f2e8b6d1287d9705102c"],
 ["Mahaleb cherry", "https://bs.floristic.org/image/o/938fde148f605dd011b314f7fea65b4fc70468d4"],
 ["Field parsley piert", "https://bs.floristic.org/image/o/ba42370aac6797ccb36352a5b672e85ca07f25a5"],
 ["Green-winged meadow orchid", "https://bs.floristic.org/image/o/56cc18dfeef0cca3f67153de05bbde57822a6ea1"],
 ["Bee orchid", "https://bs.floristic.org/image/o/752512282fc65dea442823cd2d4942ed3b6ef37a"],
 ["Viper's grass", "https://bs.floristic.org/image/o/f85bb8bf6c13b03077a3c96a76b1f01756a1d2c5"],
 ["Wormseed wallflower", "https://bs.floristic.org/image/o/0a0de1198183a9d53eb8ab8c34e76aec8a4d3856"],
 ["Yellow pimpernel", "https://bs.floristic.org/image/o/1169b86edbb05a10762f4c46e25a090ae5c2d09e"],
 ["Yellow hairgrass", "https://d2seqvvyy3b8p2.cloudfront.net/a39c00e5b54c7e36dc0f7e748e24f959.jpg"],
 ["Spreading bellflower", "https://bs.floristic.org/image/o/b0304744d2666a7f5312622555bb7eb60946e7cc"],
 ["Sweet fennel", "https://bs.floristic.org/image/o/f3d261b93096481cdd944503c123cd13db952205"],
 ["Rampion", "https://bs.floristic.org/image/o/77e822e9b8cbad216460d58fe2e83d7ba30fb095"],
 ["Black saltwort", "https://bs.floristic.org/image/o/8ac343e72efcced639a874e3612c0d486f7a3968"],
 ["Black mullein", "https://bs.floristic.org/image/o/6bbcb37be72b4f3ea6fb78a8ea890943e7aa711a"],
 ["Skullcap speedwell", "https://bs.floristic.org/image/o/261e5cf5fdf9293a581849e4c138ee53e60728d9"],
 ["Shoreline figwort", "https://bs.floristic.org/image/o/8be203a1d7374b180fb4a6590eda721e00ffaccb"],
 ["Giant goldenrod", "https://bs.floristic.org/image/o/96b256c52e733ff98e45ef335f1c8afb0ea71618"],
 ["Splitlip hempnettle", "https://bs.floristic.org/image/o/9807ab393062f04dcd369abbd32429b052283b2e"],
 ["Stiff hedgenettle", "https://bs.floristic.org/image/o/753251a744d939ecd2a364ef2fe49473e1329302"],
 ["Maiden pink", "https://bs.floristic.org/image/o/a4a1aaa271e0adbdc3442707e962fbfce8e8ce8f"],
 ["Dwarf nettle", "https://bs.floristic.org/image/o/04d62d99fcbcdb4c61ca9095bbd228a3a934e8ea"],
 ["Mosquito rush", "https://d2seqvvyy3b8p2.cloudfront.net/5411f6abf7c2d7e96efd22184bcb0e59.jpg"],
 ["Large bittercress", "https://bs.floristic.org/image/o/6c1a5122c9d4cebc17df68a4c45be27e339b8214"],
 ["Lizard orchid", "https://bs.floristic.org/image/o/f398c63dd07da905321a5545bb67f33455a2daa2"],
 ["Peachleaf bellflower", "https://bs.floristic.org/image/o/a2f6c77192837a43da4b81d493efb8cd8b4a9e93"],
 ["Greater tussock sedge", "https://bs.floristic.org/image/o/a6a87fae28eb8eaea13d11602c3256a2937c840f"],
 ["Bog orchid", "https://bs.floristic.org/image/o/fc8449ee2ffc1f82465b04de56513b5af71a42b5"],
 ["Longstalk cranesbill", "https://bs.floristic.org/image/o/6be520a9776da0c92b4d6810ce3f0f8c863b2787"],
 ["Albaida", "https://bs.floristic.org/image/o/352f99f126fa1bc332afe6003239111cfee2d2de"],
 ["St. peter's-wort", "https://bs.floristic.org/image/o/748f1d5c6b904395155f654b86a157b797370706"],
 ["Red sandspurry", "https://bs.floristic.org/image/o/163e870b3c72c5f63cc250b646066afdae4a8850"],
 ["Autumn crocus", "https://bs.floristic.org/image/o/26c81fb3322557947012747425261be6fc28bca6"],
 ["Sweetclover", "https://bs.floristic.org/image/o/ec609cf21a82fc3b2a1f6c480a4df6a5965a39da"],
 ["Cowpea", "https://bs.floristic.org/image/o/0c715b17540a8b50e17bd4c44e6c94f955b91d1f"],
 ["Marsh valerian", "https://bs.floristic.org/image/o/859c617ce59e9782f28ca16d0917fcd1fadde275"],
 ["Brown orchid", "https://bs.floristic.org/image/o/56cda22ae6a780418e0c060ad1446339ba7338fd"],
 ["Finger sedge", "https://bs.floristic.org/image/o/47109cb9aefe059fdea6d924d804c51e0acb335a"],
 ["European crab apple", "https://bs.floristic.org/image/o/d6f54a4515fbf72582ba01707a44a9d5ac759dbd"],
 ["Oxtongue", "https://bs.floristic.org/image/o/3134d72b3ddbfe8d26fcb1fef0b774e8e13226ba"],
 ["Hedgerow geranium", "https://bs.floristic.org/image/o/681b874be13f040bcb3f03f743a51393902e0c9a"],
 ["Green bristlegrass", "https://bs.floristic.org/image/o/6d27277b41548aa486b1fe0b8a667d7a615b3697"],
 ["Great water dock", "https://bs.floristic.org/image/o/497b35833e141e2d44ee645ea04c4eb7064960b7"],
 ["Mother of thyme", "https://bs.floristic.org/image/o/4b2335bbb3550e13b5096a702d01427304c5e06a"],
 ["Blue moor grass", "https://bs.floristic.org/image/o/24e051dd040baadbd10c3c497a7b26751dddf1f8"],
 ["Sidebells wintergreen", "https://bs.floristic.org/image/o/d0ff02411e7b19aa16c118750b6abc6faeaafdda"],
 ["Star of bethlehem", "https://bs.floristic.org/image/o/27628ace44c496619ab5f8e5bd912188357e9c22"],
 ["Bear garlic", "https://bs.floristic.org/image/o/ea9047a42adb0babc0ffaa43e7221bd584fdb995"],
 ["European sanicle", "https://bs.floristic.org/image/o/f5fb03d18076f56d2f842c922b3e72331d0d6bd6"],
 ["Musk mallow", "https://bs.floristic.org/image/o/80b6acc7f5b3e1720df4b9ba09bc408a5b05a26d"],
 ["Boxelder", "https://bs.floristic.org/image/o/cdf9f30ae2819e928fc1d152e9434e83e1b4556d"],
 ["Sweetgale", "https://bs.floristic.org/image/o/c074f4b51a3cbc0a511176b9b5eb272ce727ca5a"],
 ["Salvia cistus", "https://bs.floristic.org/image/o/a39dec1fbc41b62c3431388c001deaaa44eb9b4b"],
 ["Canada goldenrod", "https://bs.floristic.org/image/o/c5b23d6a26b42aa1e025fb911caec79dd23e4163"],
 ["German ipecac", "https://bs.floristic.org/image/o/25f3cbd80520e44ba7fd62647c1aef99d0a626ec"],
 ["Muskroot", "https://bs.floristic.org/image/o/e1055da4f3bde801953685bca1b899e4bd6f1e96"],
 ["Great wood-rush", "https://bs.floristic.org/image/o/6c22b43c84aa31c8f4e4dfb5ae446aea0a9fd003"],
 ["Blindeyes", "https://bs.floristic.org/image/o/48ea23a442f38a3845dd4f1da867bad7f11d0d6b"],
 ["Eurasian catchfly", "https://bs.floristic.org/image/o/99bbf5dfe9c636b939bbb57389cce6525a984ec8"],
 ["Scotch heath", "https://bs.floristic.org/image/o/0964c9955b7a0aec350d88434539cc9403a70173"],
 ["Spring wild oat", "https://bs.floristic.org/image/o/a9319fd61f80c903fd38b4e77389381053a9a64c"],
 ["Garden tomato", "https://bs.floristic.org/image/o/400851a79391dbe6f667c66e4bf70299e9921853"],
 ["Bats in the belfry", "https://bs.floristic.org/image/o/2e778d4f718a345e0b82b1f65ed078aa0a8331a6"],
 ["Cosmopolitan bulrush", "https://bs.floristic.org/image/o/1658a917a28a7a3cf91815f1669a7586ecdffe2c"],
 ["White poplar", "https://bs.floristic.org/image/o/fae7ede0f0fb6e7fd6c57c7f48c93af9262cb13a"],
 ["Vernal sedge", "https://bs.floristic.org/image/o/cb2b6f310bf9d7f61069ebd49f89e81d0d79c758"],
 ["Coscoja", "https://bs.floristic.org/image/o/c7d6434e0fcb6c73893e93a22241a6d76750fa5b"],
 ["Cassava", "https://bs.floristic.org/image/o/84adae73a276fc2ff0a9916ecf86f794b3c8ba76"],
 ["Garden yellowrocket", "https://bs.floristic.org/image/o/1766b0a83298a8fa3e989cff29787f0d34fa18eb"],
 ["Paradise plant", "https://bs.floristic.org/image/o/54cf4392c8795d2502adfb5454fc815d3feb231f"],
 ["Lentil vetch", "https://bs.floristic.org/image/o/bf9391e45c6c3aea6cf5c23595e2b1516b4e4981"],
 ["Garden thyme", "https://bs.floristic.org/image/o/8709185087a881e96ffc55ce766b53f7e861cb3b"],
 ["American pokeweed", "https://bs.floristic.org/image/o/01eaf50d79a5ee24bf60604e6ce908095f85dff4"],
 ["Blister sedge", "https://bs.floristic.org/image/o/70ffafcbbed57bf60e2ace629e325c06724ac310"],
 ["Hart's tonguefern", "https://bs.floristic.org/image/o/d8425a074b04a7b46656b306e932fffb437ece63"],
 ["Wine grape", "https://bs.floristic.org/image/o/fe4637252c61b28b52b11fdf77ebdca3258c3498"],
 ["Carline thistle", "https://bs.floristic.org/image/o/caf89a152b227ffdfa86abe117c53a09cba16bc8"],
 ["Checkertree", "https://bs.floristic.org/image/o/6e494eac6cbbff721faff124f3c01261c447e727"],
 ["Little hogweed", "https://bs.floristic.org/image/o/5defe82d91173cf9450c2f4bc7b673ccd715003e"],
 ["Northern red oak", "https://bs.floristic.org/image/o/9dda465d52b05d7d69125723fafbdf95742dcb46"],
 ["Great yellowcress", "https://bs.floristic.org/image/o/819637bca8e88ba8cf26a0d8e2de091b68dcf830"],
 ["Bermudagrass", "https://bs.floristic.org/image/o/0192e86802164511ddeb22abbb0fe534861cc941"],
 ["Oxlip", "https://bs.floristic.org/image/o/a8b199a757751c24af8e014aa813072811265e01"],
 ["Meadow saxifrage", "https://bs.floristic.org/image/o/53bacb1c252d928437456dd129d925af16b7662e"],
 ["Clustered dock", "https://bs.floristic.org/image/o/3bc80610ce295a67bc9ba2c9fe4ccc476d303d7f"],
 ["Arctic starflower", "https://bs.floristic.org/image/o/d183e5579ac8bd3701adb461e010530bfcbee3b4"],
 ["Sago pondweed", "https://bs.floristic.org/image/o/457d67707f9cc06d79701e5a55f2beabf2defd7c"],
 ["Marsh hawk's-beard", "https://bs.floristic.org/image/o/651ada6cc09692c9284c68566f18a14091c02263"],
 ["Kenilworth ivy", "https://bs.floristic.org/image/o/2cdc3967e62b72ebeaaff9a1a01d5a263dcc4169"],
 ["Horse chestnut", "https://bs.floristic.org/image/o/6b9815440b4c2a0830f3c8a810dbc93c1cff4bae"],
 ["Black-bindweed", "https://bs.floristic.org/image/o/38c88d452ce4d744300ce58eb1ff7e70d3c84b9c"],
 ["Rough chervil", "https://bs.floristic.org/image/o/505b0e497b21ac67cf196a7085139428abb8bbb7"],
 ["Common orache", "https://bs.floristic.org/image/o/1bcc70e32d8da13cf3cf0265b15e86e2735791ba"],
 ["Common pear", "https://bs.floristic.org/image/o/df1f10b61c416dae1abbeb8f3e01e7fba9f5e38c"],
 ["Common buckthorn", "https://bs.floristic.org/image/o/c40162e8b07333cbed394d7bb2e19664a4ecac63"],
 ["Bay forget-me-not", "https://bs.floristic.org/image/o/559b12ea24458e4289ce8017ac18e48a679f9aa4"],
 ["European gooseberry", "https://bs.floristic.org/image/o/8f23b9d01b660c5a2085192a6ddc761939900900"],
 ["African boxthorn", "https://bs.floristic.org/image/o/d5546cc3ab9b3cec6a204894f6dabfd6611e58da"],
 ["Elmleaf blackberry", "https://bs.floristic.org/image/o/f303e26504d136491fb2e62e3747d51956c3ba5d"],
 ["Early purple orchid", "https://bs.floristic.org/image/o/79da00e7694223479636b02b70fae0c30879c572"],
 ["Strawberryleaf cinquefoil", "https://bs.floristic.org/image/o/b1d0c0b855f839c2b1d0789ed7c041a325820123"],
 ["Stone bramble", "https://bs.floristic.org/image/o/1789e46d7dbf830bd13dae7ace1e39ddde587dc1"],
 ["Woodland bittercress", "https://bs.floristic.org/image/o/77e0cf0ad4251da1fc4839c50b0ab5fd26921d33"],
 ["Stoloniferous pussytoes", "https://bs.floristic.org/image/o/7850fa51e9a7ed575e9f60ce7001cf4c4b5d7a87"],
 ["European centaury", "https://bs.floristic.org/image/o/99145b6fa2526eedfecbfc5764145419438651d7"],
 ["Annual mercury", "https://bs.floristic.org/image/o/3a39bff9d53b2abe41e8f524f710c97ccb6d4420"],
 ["Common beet", "https://bs.floristic.org/image/o/f97e48f2dc9c0a801fb443f0268d2eda6034d55a"],
 ["Garden pea", "https://bs.floristic.org/image/o/de42bcb86806a72660b5d46d06b2ae40e25610d2"],
 ["Field chickweed", "https://bs.floristic.org/image/o/28a7ee33a19ec33b098fa5aaa1231b9fe72935b7"],
 ["Greater knapweed", "https://bs.floristic.org/image/o/e871111397c8394b36e3da37747e21fd50c48c05"],
 ["Lampwickplant", "https://bs.floristic.org/image/o/032ade4e5c13bbb109c4a58f8f27ef82e14e6b34"],
 ["White sweet-clover", "https://bs.floristic.org/image/o/fcd94143219ddd1b8c2fd46821a40096b191db78"],
 ["Marsh grass of parnassus", "https://bs.floristic.org/image/o/0b38896e0dde2076492e96581cb323e6ccf6fda9"],
 ["Manyflower marshpennywort", "https://bs.floristic.org/image/o/bfe0b7e5c47393687e26167e7c83c0e70ba47f06"],
 ["Yellow oatgrass", "https://bs.floristic.org/image/o/62a2196bc9bcb3854bc9b91dd388b6038fd6e772"],
 ["Petty spurge", "https://bs.floristic.org/image/o/83787a92cebdce3747a56a2e7fadae89127fa81f"],
 ["European columbine", "https://bs.floristic.org/image/o/3222de33ac56c14aca1fc52a4c9a8b7cf2eacbe1"],
 ["Herb of the cross", "https://bs.floristic.org/image/o/22e44204de0bc006e68ff41115a566eaa641cc49"],
 ["Heath bedstraw", "https://bs.floristic.org/image/o/ea0afa789cffb6f889eb6292d13c79adcbb8e880"],
 ["Wall germander", "https://bs.floristic.org/image/o/c75a0d56819554e582f592efc743353bf0925ba7"],
 ["Barnyardgrass", "https://bs.floristic.org/image/o/711245036758ec42d58f60612ad7af27709d89d4"],
 ["Fringed willowherb", "https://bs.floristic.org/image/o/6ca9c6897c5a5c1dbb4effa782f49ed67140473e"],
 ["Tasmanian bluegum", "https://bs.floristic.org/image/o/2399066e403757d991cdbb2f1e6d4ad2eeba1d63"],
 ["Slender tufted-sedge", "https://bs.floristic.org/image/o/ce107d2390e37f3c9b08bf022dace1440c0234ce"],
 ["Herb-paris", "https://bs.floristic.org/image/o/93d20eb325ba02728f2ee12f6607316d80d10237"],
 ["White thyme", "https://bs.floristic.org/image/o/05de2907d4e8aca5c2b17cdc7ee88c7436dbb4e0"],
 ["Sweetscented bedstraw", "https://bs.floristic.org/image/o/52e31ca95027d029366c60042fed4952c81dd147"],
 ["Ivyleaf speedwell", "https://bs.floristic.org/image/o/0719a6630a3fde35fbb53f75840217b4884924d4"],
 ["Black cherry", "https://bs.floristic.org/image/o/505fe4b51ed389bd35645fdb9db3dbd17c6d01b7"],
 ["Wild basil", "https://bs.floristic.org/image/o/a5b9f297e111b150a4e7a7e29d9bbb8eebc6c0f0"],
 ["Lombardy poplar", "https://bs.floristic.org/image/o/d63c803bbf2fdb083dfd8e3c5dfe8cf575dd76e5"],
 ["Fragrant orchid", "https://bs.floristic.org/image/o/08e72356d8cabd99f28a22f2bbd6b9d6c44f0e69"],
 ["Smallflower hairy willowherb", "https://bs.floristic.org/image/o/7d2722e2ea326314fe6ddbabd81934cb1a26e4ef"],
 ["Common hedgenettle", "https://bs.floristic.org/image/o/acc6e30820a49ab9384d0eb4eebb6b047f9b21a2"],
 ["Christmastree", "https://bs.floristic.org/image/o/8e171a19f992a34d5d44693472320f6044a5d561"],
 ["Cade juniper", "https://bs.floristic.org/image/o/955f7c623c2f99dc1480b44b6de954c958a0d28b"],
 ["Wild mint", "https://bs.floristic.org/image/o/d3097f130ca6c054b04f9d1681805ce2f147f4a1"],
 ["Cursed buttercup", "https://bs.floristic.org/image/o/e471226a961a9e1d21a38af886cd944b789f14f9"],
 ["Mouseear cress", "https://bs.floristic.org/image/o/6313bb777f36d2c95d36ae6b92c27a2cf5c67cf0"],
 ["Marsh hedgenettle", "https://bs.floristic.org/image/o/9389ac24c8d9e6c33660ee7b12b3a20f75e54ccf"],
 ["Broadleaf enchanter's nightshade", "https://bs.floristic.org/image/o/2676cd4fc5594ddb5be48a9ede236e7f6629af9f"],
 ["Common milkwort", "https://bs.floristic.org/image/o/9173386eec56985e3888cbbbf16fb6b73fc38dcd"],
 ["Wild parsnip", "https://bs.floristic.org/image/o/a0d90dc4eda6b06b6762d38e7c5f6ae45cee99b1"],
 ["Downy oak", "https://bs.floristic.org/image/o/bf115f5afb11760a269f264c2386818c5a33ffbe"],
 ["Bigleaf lupine", "https://bs.floristic.org/image/o/6211dc65f2c5a29293b19acbc774ff28ca4cc5f2"],
 ["Woodland horsetail", "https://bs.floristic.org/image/o/d5a837d773356d89f1c7796afb6e3226323d3071"],
 ["Soybean", "https://bs.floristic.org/image/o/6718590e12991ecffc1c3de14a637bc18b6a5582"],
 ["Velvet bent", "https://bs.floristic.org/image/o/044f0a0fed243fa02d46e8f3183e360effa4c347"],
 ["Goldmoss stonecrop", "https://bs.floristic.org/image/o/7357a578a85db587cd5f99427d55cdfe524fd8f5"],
 ["Sticky chickweed", "https://bs.floristic.org/image/o/cda681ea0545e718a26b722922d29e5b4368212b"],
 ["Cuckoo pint", "https://bs.floristic.org/image/o/ca6349213874da50217d49a40ed2b3cbc1156852"],
 ["European meadow rush", "https://bs.floristic.org/image/o/7e5468c95ae5c63349e1b5e1800497d3f88230d8"],
 ["Woodland geranium", "https://bs.floristic.org/image/o/2a639887f46d96f2796385c16f69a9b3525a959d"],
 ["Spring draba", "https://d2seqvvyy3b8p2.cloudfront.net/f0aa280c838cdba3c7c5aaeeafa5629a.jpg"],
 ["Broadleaf helleborine", "https://bs.floristic.org/image/o/99e3a1bc907a43fea411f806201c1b1b63edcace"],
 ["Wayfaringtree", "https://bs.floristic.org/image/o/7d45264dab00489f66411c56435a6189aa2e4133"],
 ["Fig buttercup", "https://bs.floristic.org/image/o/e24480b8f6665171c3d1b002236b0d7c1ead02db"],
 ["Fairy flax", "https://bs.floristic.org/image/o/80c89954928b766a802240c6928f580a13fabb59"],
 ["Common twayblade", "https://bs.floristic.org/image/o/8166af06df01d49b1b5d37eac48084eddda32d81"],
 ["Creeping jenny", "https://bs.floristic.org/image/o/c55ab9cd667f67f58f588f9647b3a3c6ce70ef10"],
 ["Thymeleaf speedwell", "https://bs.floristic.org/image/o/d4ea4269eee85f54b5c026f8095723f9e1d58dce"],
 ["Dog mercury", "https://bs.floristic.org/image/o/672b45e7c21c883db6f529926d352ec1e2799b5e"],
 ["Eurasian solomon's seal", "https://bs.floristic.org/image/o/e513838b2545f84cfaf629421848e310cadadb30"],
 ["Black crowberry", "https://bs.floristic.org/image/o/45ce821504235ca030e57b9e2079cec287b51c5c"],
 ["Common kidneyvetch", "https://bs.floristic.org/image/o/444db0c8a204e17c7f96cc1d5f60e4f72d395861"],
 ["European field elm", "https://bs.floristic.org/image/o/876b7045c03635e3240f3318f7c0d2163f6ccbdb"],
 ["Hoary plantain", "https://bs.floristic.org/image/o/6c39eea202bcc77c7550f75559570a5a2c4b6231"],
 ["Birdeye pearlwort", "https://bs.floristic.org/image/o/fe1b945cb305430e8002b7b4ce7cd19fbaad8744"],
 ["Willowherb", "https://bs.floristic.org/image/o/ab2200e1dbca9a8590cbbf418c9beb884bf13d7b"],
 ["Common cow-wheat", "https://bs.floristic.org/image/o/09ad670af3afe7c52b188e0c31109b191203233f"],
 ["Bog blueberry", "https://bs.floristic.org/image/o/48f203639b32c2bb89039117b964fa371f15e6a6"],
 ["Hairy woodrush", "https://bs.floristic.org/image/o/84d865e7b7240c5dca8cdc5e318394e120722aa9"],
 ["Hairy bittercress", "https://bs.floristic.org/image/o/425577b3d196e51fb9b7bea0ab586c0ab61cf041"],
 ["Black nightshade", "https://d2seqvvyy3b8p2.cloudfront.net/cc37d08ad4fae274ee3e60c405bb8dec.jpg"],
 ["Common polypody", "https://bs.floristic.org/image/o/f56b0e73b215539b4adf4114168eb5e1dca77e72"],
 ["Alfalfa", "https://bs.floristic.org/image/o/ba7e729e76110e9f174830f551c54ee6613a81a6"],
 ["European lily of the valley", "https://bs.floristic.org/image/o/019173a51a75465d4d29eb15c627cc262da57865"],
 ["Cutleaf geranium", "https://bs.floristic.org/image/o/404e8ad4f5dd5797569cf9b50147ad3ac0fe37f7"],
 ["Common spikerush", "https://bs.floristic.org/image/o/f53e8fa92fc8914b1f492703bc3976e098570ec0"],
 ["Ornamental jewelweed", "https://bs.floristic.org/image/o/a9f1c65ecf40c2e41bbe453dbfbabea6ab54d590"],
 ["Prickly lettuce", "https://bs.floristic.org/image/o/7b1eed4edf538b2843ba853c5a8ee8198ec591d3"],
 ["Mastic tree", "https://bs.floristic.org/image/o/3fa8be5a03098ee8f6ea87d8ca113f6ced4cf805"],
 ["Reed mannagrass", "https://bs.floristic.org/image/o/bca74fca6e5c159eea042e3d6e2ba2b67e4be3bb"],
 ["Woodland figwort", "https://bs.floristic.org/image/o/ab896abdd1d8d5fca0ca108d0ca42f7981828bed"],
 ["Compact rush", "https://bs.floristic.org/image/o/ff97f4654ebd9a1b402ad46f080f3bfc493b0746"],
 ["Heath false brome", "https://d2seqvvyy3b8p2.cloudfront.net/e1298352327320880a79d707bdf45a54.jpg"],
 ["Field forget-me-not", "https://bs.floristic.org/image/o/5052a429215508a708e6e460a5979ca9fb8a5ebc"],
 ["Jesusplant", "https://bs.floristic.org/image/o/2fbd50d1d3c58a5c19f220aff8f14acb0bf6f701"],
 ["Cypress spurge", "https://bs.floristic.org/image/o/b9df02442d5b8df7dc408ddedf8ac9cc07819ea4"],
 ["Redstem stork's bill", "https://bs.floristic.org/image/o/2bfdd76139914cb68159ea04db792cfcf4b01bf5"],
 ["Toad rush", "https://bs.floristic.org/image/o/b4112a49bf8a2a27288a25dc83b3f9d68f8e9a9c"],
 ["Woodland germander", "https://bs.floristic.org/image/o/6aa47d0493de0be013968af8a37de725689b7238"],
 ["Hammer sedge", "https://bs.floristic.org/image/o/cbe1f2378de7a8f90916807b9764b7e683fce71c"],
 ["St. anthony's turnip", "https://bs.floristic.org/image/o/a905a16ddae6a7e27460260d30b59c84359c0f5b"],
 ["Common rivergrass", "https://d2seqvvyy3b8p2.cloudfront.net/e43d68b4a761ec896c9f51d4ee4672a5.jpg"],
 ["Lingonberry", "https://bs.floristic.org/image/o/4b74f7a694456a0297589e393db4dc35753cb5e2"],
 ["Durmast oak", "https://bs.floristic.org/image/o/d6e87a3672c022443d3f72a9457ab658155c2ed3"],
 ["Disc mayweed", "https://bs.floristic.org/image/o/d65ee11c213cec3b40d8da93a1dbad7285a60ced"],
 ["Common comfrey", "https://bs.floristic.org/image/o/accc73a55618151e146e09e0f002f736bcc542f9"],
 ["Toadflax", "https://bs.floristic.org/image/o/edff32fc2bf63b7b4098cfd088515ede32870ec5"],
 ["Tall cottongrass", "https://bs.floristic.org/image/o/90f2485bfae1f4c2dc71a215ef44cef762430e40"],
 ["Kidney bean", "https://bs.floristic.org/image/o/46b23b23e98319531962424fb9d88a4656610a0b"],
 ["Crested dogstail grass", "https://bs.floristic.org/image/o/668a5e74aff488d054f8530da0f43ce722636f67"],
 ["Marsh horsetail", "https://bs.floristic.org/image/o/a90d1a2cf9ffb04639b6b2ba77656726fa1dd52d"],
 ["Matgrass", "https://bs.floristic.org/image/o/2e76e4226c9462d6739dc033eb1fbb391b4a92fd"],
 ["Bush vetch", "https://bs.floristic.org/image/o/b4959dd4c15678a9fece3bd6479ec6e64b5d674b"],
 ["Garlic mustard", "https://bs.floristic.org/image/o/d56189572271b41efd3e6c0576fa1581aab31ca1"],
 ["False baby's breath", "https://bs.floristic.org/image/o/8d555fb455adba7381812cfc29949d4f8fe84bde"],
 ["Spiny sowthistle", "https://bs.floristic.org/image/o/f6f9adb63613db1d051e538d45da46e09961f77a"],
 ["Mouseear hawkweed", "https://bs.floristic.org/image/o/44e695a74c98dbaff809fe95fd4bdb3a3874aa12"],
 ["Jointleaf rush", "https://bs.floristic.org/image/o/dc2c491ce675d1646ec59f0c68cb3a4b52c68766"],
 ["Purple deadnettle", "https://bs.floristic.org/image/o/dfd80f8ba30a21b35a3dee2a64f08fe97a31ad20"],
 ["Norway maple", "https://d2seqvvyy3b8p2.cloudfront.net/d07382709196c9b7b156a5f9cdde0ff1.jpg"],
 ["Field woodrush", "https://bs.floristic.org/image/o/ab30b7b483e521bcb26a1c2a66d2843593dbe66d"],
 ["Field bindweed", "https://bs.floristic.org/image/o/79250f254e938f24393f1121d04db09988bc4771"],
 ["Common barley", "https://bs.floristic.org/image/o/73c0b2192795aca45295f52c865301868efb96f0"],
 ["Water mannagrass", "https://bs.floristic.org/image/o/ebed9cbd10da17f5b0843defe635b14942c2d2ff"],
 ["Water mint", "https://bs.floristic.org/image/o/04fdf5bbfec0530275456e500ef895fd02514de6"],
 ["Brownray knapweed", "https://bs.floristic.org/image/o/54b123e462a00363c26ddbc11e2718bf3a22dd6c"],
 ["Dog rose", "https://bs.floristic.org/image/o/658bff43fbf3b22296b0206094ab2d01852c41e5"],
 ["Coltsfoot", "https://bs.floristic.org/image/o/aac55e0d70d06a3a9bfd9bf308060a5862eaed91"],
 ["Bluebell bellflower", "https://bs.floristic.org/image/o/1092c6ac6110072934460a3229ad9d7f8eddde1d"],
 ["Climbing nightshade", "https://bs.floristic.org/image/o/7b15bbcefea0bb4bf6e40a541e05fa08f61cf184"],
 ["English holly", "https://bs.floristic.org/image/o/fc1daecfd73245ca1fe69ac45dfca5de7002ef13"],
 ["Meadow campion", "https://bs.floristic.org/image/o/54cde4c61064d894d2d9210cdb6d0337d291f0ba"],
 ["Wood anemone", "https://bs.floristic.org/image/o/5e99297ccd0f697d33b853ec5e3013eb97a018da"],
 ["Glossy buckthorn", "https://bs.floristic.org/image/o/09568bda13ff18487860da26ec87d7048fe53437"],
 ["Hemp agrimony", "https://bs.floristic.org/image/o/35ebd5ab1e490e9511fb1135e4f135b51a9f0b3d"],
 ["Heath sedge", "https://bs.floristic.org/image/o/a07d1ccd6dd5e614707bc07585d198fed4a690e6"],
 ["Lambsquarters", "https://bs.floristic.org/image/o/e7df6ee32ff10bc01f306e6e49088493a3498cac"],
 ["Old-man-in-the-spring", "https://bs.floristic.org/image/o/789db8a83a9ab9719d711d0169221e46ad78e567"],
 ["White birch", "https://bs.floristic.org/image/o/8531ad6f5a55aba51e96361251eeb0ea2db80494"],
 ["Asplenium ladyfern", "https://bs.floristic.org/image/o/081e49b548661f596e399a5744a04b03a6581912"],
 ["Common nipplewort", "https://bs.floristic.org/image/o/e1c0aa456697d6b67b2e2c246f79dda08782e4e8"],
 ["European hornbeam", "https://bs.floristic.org/image/o/a43937800f97e92322d9a2bc7ca1311bed3b7b45"],
 ["Creeping cinquefoil", "https://bs.floristic.org/image/o/cbb89f55b3cb345b1beec06250046640079fccec"],
 ["Codlins and cream", "https://bs.floristic.org/image/o/5fff85d7218e63340017bdcdcc323ef26efbce32"],
 ["Yellow marsh marigold", "https://bs.floristic.org/image/o/f5627b0925fe075118382b8d7ffea50817f47eb7"],
 ["Black medick", "https://bs.floristic.org/image/o/261eb8ea6e09e73f501315c854a604a5914100a7"],
 ["American red raspberry", "https://bs.floristic.org/image/o/f314ae0b8615c650c2492ec0f16964b11a631de9"],
 ["Curly dock", "https://bs.floristic.org/image/o/6a6ef17a9d39da5969cb33bcd6030afafd514952"],
 ["Paleyellow iris", "https://bs.floristic.org/image/o/5de9ad057e5a24bc00d25f1f4df5ff4025c98257"],
 ["Garden vetch", "https://bs.floristic.org/image/o/2d78b1ec932e8fa41749ae9f2eab1baabc917fe6"],
 ["Timothy", "https://bs.floristic.org/image/o/0bd39560359703ce00003c31e9e95f9f851df1c5"],
 ["Sweet cherry", "https://bs.floristic.org/image/o/cfa5920450191946aa0b400f08a8763e108a4641"],
 ["Western brackenfern", "https://bs.floristic.org/image/o/eaa1e69cec1d11160144f54a337e66dbf5ab8a45"],
 ["Oxeye daisy", "https://bs.floristic.org/image/o/cc03c870f80172d0faf20d14ff8291d050afd13f"],
 ["Quackgrass", "https://d2seqvvyy3b8p2.cloudfront.net/80f1ec52846152e047da188e56b970c4.jpg"],
 ["Purple loosestrife", "https://bs.floristic.org/image/o/e42dd296a1fd0fe265bde29e60175cb9326bb9ec"],
 ["Whortleberry", "https://bs.floristic.org/image/o/6bf7a0827cc0d59e8e43304ee00858a32cf6467f"],
 ["Germander speedwell", "https://bs.floristic.org/image/o/2b8bd09230b0f06ab9fa52f4c4023d485c91c2a4"],
 ["Reed canarygrass", "https://bs.floristic.org/image/o/8ef6dfd8db76016394ccb54cd75baca93105e165"],
 ["Norway spruce", "https://bs.floristic.org/image/o/839086b536fc2782b9c1cc0f9687b97f3a18ef43"],
 ["Herb bennet", "https://bs.floristic.org/image/o/8a5a9fed6cdcf07097e8f8cbe71f154dfba074ce"],
 ["Field horsetail", "https://bs.floristic.org/image/o/f4a835b6ae1d6eadd4033990066759428648d86a"],
 ["Hairy cat's ear", "https://d2seqvvyy3b8p2.cloudfront.net/6d0af0bfb352c0254ea3019d7b6a5844.jpg"],
 ["Woodland angelica", "https://bs.floristic.org/image/o/3eb27cbd0ad74eb598dfdd2313e0422d35d25199"],
 ["Queen anne's lace", "https://bs.floristic.org/image/o/1a8e32a56cb9c6202c1e5b58898ea11ad6b00d4d"],
 ["Cork oak", "https://bs.floristic.org/image/o/18d98dce42b463a97cca4e642ab61aecce8c74f6"],
 ["Bull thistle", "https://bs.floristic.org/image/o/8d152c039c42720f282359e792954734ebfa6d89"],
 ["Lawndaisy", "https://bs.floristic.org/image/o/055448a32f8bbf37a1a43dd807385373410bfcf0"],
 ["Erect cinquefoil", "https://bs.floristic.org/image/o/5487d9cebda9ab860383eef1cdf11aad0fcf3db7"],
 ["Common st. johnswort", "https://bs.floristic.org/image/o/6e7a63228d463cba1f0b9f5a58ccc9436f2778f3"],
 ["Purple moorgrass", "https://bs.floristic.org/image/o/b5a10b8476cda289a13eeb246ae9fcd0270faac7"],
 ["Kentucky bluegrass", "https://bs.floristic.org/image/o/6e25db3d223a2e7b26a3c762c4861ab5fb9010ac"],
 ["Common selfheal", "https://bs.floristic.org/image/o/b46f4000f9bec28dc6d74d501ddc15445e7f7667"],
 ["Tufted hairgrass", "https://bs.floristic.org/image/o/8193be51b20eb8bd28a29d67dd96e9287ddbcbec"],
 ["Blackthorn", "https://bs.floristic.org/image/o/74001fa4fbba45263756df516209aba8525620f9"],
 ["Mountain wavy hairgrass", "https://d2seqvvyy3b8p2.cloudfront.net/36096e9d4ceb8271fde266276ce454f1.jpg"],
 ["Robert geranium", "https://bs.floristic.org/image/o/15aff4c873c771b9ea9ded1648b7b23b8641a2a5"],
 ["Eltrot", "https://bs.floristic.org/image/o/795061348098dfe2c4cdedd6a5dcb5c9db848d55"],
 ["European white birch", "https://bs.floristic.org/image/o/8b54826c7cc96e83f953ea09872ee3026c8d598e"],
 ["Perennial ryegrass", "https://bs.floristic.org/image/o/f5b89a095969703e65d37a83c28a2d7af125b839"],
 ["European alder", "https://bs.floristic.org/image/o/2730cc06110e471d878bf14af815f83905866a64"],
 ["Common mouse-ear chickweed", "https://bs.floristic.org/image/o/38a8a07c9c0cd6083b2a8dca1be4ac7f0e49b709"],
 ["Common wheat", "https://bs.floristic.org/image/o/d4d05e22148e878ca3728beda0139b6dbe42fa3c"],
 ["Black elderberry", "https://bs.floristic.org/image/o/594bda8000b118433847bf0973eb397de8a87543"],
 ["Stickywilly", "https://bs.floristic.org/image/o/dda8d72438e461abaca1e717c43b1555d2727bc8"],
 ["European mountain ash", "https://bs.floristic.org/image/o/63073d2fbf45b90701279405ecc2eec0272906ed"],
 ["Ground ivy", "https://bs.floristic.org/image/o/d7aa2ca54f628e1f5a67dd672aeebb006d281a9b"],
 ["Rough bluegrass", "https://bs.floristic.org/image/o/8e4f8472f36f36175a8d2fca4723059699f9d46e"],
 ["Bird's-foot trefoil", "https://bs.floristic.org/image/o/c2180ef57b83b419e4b851c058003d56ad2c6bbe"],
 ["Scots pine", "https://bs.floristic.org/image/o/33d84b84c09347d360afa0d610e220664cfb6d93"],
 ["Common reed", "https://bs.floristic.org/image/o/1155e1614588374ce93aedb701ae8483e2cae45f"],
 ["Common plantain", "https://bs.floristic.org/image/o/36c2225c7d24a897eaf055e99eac26b3f5ceffa3"],
 ["Sycamore maple", "https://bs.floristic.org/image/o/d2747c12a135a00ff8e6d8af86acbec3c6f8248d"],
 ["Queen of the meadow", "https://bs.floristic.org/image/o/f5f2a3d241dcd22e237cdebdbf770477721516f0"],
 ["Sweet vernalgrass", "https://bs.floristic.org/image/o/fcf64ef0676db8ca9d2abf4017f5b8211b10e0b1"],
 ["Garden sorrel", "https://bs.floristic.org/image/o/780b9f3c63318588b8874d608c2d4900fc2adce3"],
 ["Common rush", "https://bs.floristic.org/image/o/93041212342d6e8f9f544fd55000c037485a360e"],
 ["European beech", "https://bs.floristic.org/image/o/a733221df31a1ff99af03566841744f3b4c6cffe"],
 ["Common filbert", "https://bs.floristic.org/image/o/0d92cadb0d66dce1b0a8b26913125d6501e31d68"],
 ["Tall buttercup", "https://bs.floristic.org/image/o/8390d605e1947cb44e24af9492f96df4a34e8ca8"],
 ["Red clover", "https://bs.floristic.org/image/o/7eb243363838c9975c57204057e63fa8101c26d8"],
 ["Oneseed hawthorn", "https://bs.floristic.org/image/o/26b1520c799177ee1b7c4a27f9f46c4ace617dd2"],
 ["European ash", "https://bs.floristic.org/image/o/56cbb2c6905b39891def2c7aa09a94d63a0e572a"],
 ["White clover", "https://bs.floristic.org/image/o/c766ed84c547abac6021244bc0014d665ba7726f"],
 ["Common velvetgrass", "https://bs.floristic.org/image/o/46619775d4319328b2fad6f1ba876ccca2d03534"],
 ["Creeping buttercup", "https://bs.floristic.org/image/o/c6d9a5222b6ef0e3a7bdef3350278718d3097bce"],
 ["Red fescue", "https://bs.floristic.org/image/o/0b932c8a275efc79f473a71bec20d6f15e9b6b90"],
 ["English oak", "https://bs.floristic.org/image/o/2292b670683abdaac354389514105df0018d9ef8"],
 ["Narrowleaf plantain", "https://bs.floristic.org/image/o/78a8374f009e6ed2dc71ca17d18e4271ea0a2a7b"],
 ["Orchardgrass", "https://bs.floristic.org/image/o/428f40dadfa0281dc890ead17fcd07882f9efb09"],
 ["Stinging nettle", "https://bs.floristic.org/image/o/85256a1c2c098e254fefe05040626a4df49ce248"],
 ["Evergreen oak", "https://bs.floristic.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30"]]
plantarray.shuffle!

unsplashurlarray = ["https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1586710513539-8a45b43c1888?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1513432001033-4a7b14b6d039?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1594841230524-2f2b2296a039?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1521206698660-5e077ff6f9c8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1576036653836-6e3c886ca10b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1572421603654-af730fcd1db0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1518665773578-4f13f4ca356c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1588874233223-a537a7db99ea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1587021021298-522d056554b4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1575588070967-b3111bac3263?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1587546735412-3086bd5e30ec?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1528175734205-b5fa955af409?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1523296171310-b0e2cbd886d2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1527903624482-4186b06014b7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1542407242725-7d7f3d865665?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1519067438913-7aab3bff2281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1523854004673-3212647b7f02?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1551265629-2ac0284bd7cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1544834044-d638100532cb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1497250681960-ef046c08a56e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1577651442014-e399a97ca4fe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1498766707495-856f300a5821?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1579621939346-1721e97c23c8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1446831687499-c9188a15b9bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1547765487-1dbea1e08675?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1503149779833-1de50ebe5f8a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1528105862282-e4333365c1d4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1532510344496-7d508527fe81?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1506634064465-7dab4de896ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1569615880429-fcc01139e5ea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1570343096246-092fa979a4b8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1542407075-5f16837b2a26?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1525923838299-2312b60f6d69?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1493957988430-a5f2e15f39a3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1425736317462-a103b1303a35?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1513161455079-7dc1de15ef3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1457089328109-e5d9bd499191?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1440952343424-aac76da97359?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1444156073782-ad0eacb054e5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1414109918748-922adee5554a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1435783459217-ee7fe5414abe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1471899236350-e3016bf1e69e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1477554193778-9562c28588c0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1469259943454-aa100abba749?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1482003297000-b7663a1673f1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1496098868818-75736fc02eeb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1494217752358-c6c4a1a82797?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1485841938031-1bf81239b815?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1490276190462-3c300f98bfc4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1459664018906-085c36f472af?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1554477717-cad0b36509e9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1503153181849-4e4f85a341ce?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1598880940080-ff9a29891b85?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1459156212016-c812468e2115?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1466781783364-36c955e42a7f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1463154545680-d59320fd685d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1508975174-c000113b5900?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1604449075996-83127dc12686?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1606575419690-6031f2f7dbc7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1554860746-e74d5092a776?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1551970634-747846a548cb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1562507760-7a90341799e3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1573619749554-b269f758f106?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1557187764-98fe235c78f9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1491147334573-44cbb4602074?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1465155375712-7f2a9e51f0d2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1531156992292-d36397ee9184?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1440397699230-0a8b8943a7bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1556113275-d186de384a3c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1539477857993-860599c2e840?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1547550139-3422f89a82f0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1556528902-d95116c7390d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1515995891715-1dd7b8fd7823?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1490750967868-88aa4486c946?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit",
 "https://images.unsplash.com/photo-1562845858-4a657c4ef2e9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit"]
unsplashurlarray.shuffle!


# def fetch_plant_name_and_img
#   pagetracker = 1
#   resultarray = []
#   until pagetracker == 18879 || resultarray.count >= 500
#     plants_url = "https://trefle.io/api/v1/plants?token=yA9eJF8cwC4SlB3kz7nXhwlnIGHqSFDCAEgxy97hkXE&page=#{pagetracker}"
#     doc = open(plants_url).read
#     filearray = JSON.parse(doc)['data']
#     filearray.each do |file|
#       unless file["common_name"].nil? || file["image_url"].nil?
#         resultarray.insert(1, [file["common_name"], file["image_url"]])
#       end
#     end
#     pagetracker += rand(1..3)
#   end
#   return resultarray
# end

def attach_plant_icon_and_species(plant, array, unsplasharray)
  plantsubarray = array.delete_at(0)
  planturl = unsplasharray.delete_at(0)
  file = URI.open(planturl)
  plant.species = plantsubarray[0]
  plant.photo.attach(io: file, filename: 'plant-icon.jpeg', content_type: 'image/jpeg')
end

144.times do
  userurlarray << 'https://source.unsplash.com/collection/895539/100x100'
end

134.times do
  userurlarray << 'https://source.unsplash.com/collection/181462/100x100'
end

26.times do
  userurlarray << 'https://source.unsplash.com/collection/1151354/100x100'
end

def attach_user_icon(user, array)
  userurl = array.sample
  file = URI.open(userurl)
  user.photo.attach(io: file, filename: 'user-icon.jpeg', content_type: 'image/jpeg')
end

puts 'done!'

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

def user_protocol(user, plantarray, unsplashurlarray)
  rand(3..6).times do
    pricingnum = rand(1.00..50.00)
    plant = Plant.new(
      pricing: sprintf('%.2f', pricingnum.round(2)),
      user: user
    )
    attach_plant_icon_and_species(plant, plantarray, unsplashurlarray)
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
        user: User.all.sample,
        plant: plant
      )
      rental.status = compute_rental_status(rental)
      rental.save!
    end
    plant.status = compute_plant_status(plant)
    plant.save!
  end
end

def create_demo_accounts(array, plantarray, unsplashurlarray, usernum)
  array.each do |name|
    admin = User.new(
      name: name,
      password: "tester",
      email: "#{name}@test.com",
      remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s),
      latitude: 48.8651313,
      longitude: 2.3778106
    )
    file = File.open('app/assets/images/tristan-icon.jpeg')
    admin.photo.attach(io: file, filename: 'tristan-icon.jpeg', content_type: 'image/jpeg')
    admin.save!
    user_protocol(admin, plantarray, unsplashurlarray)
    usernum += 1
    puts "users created: #{usernum}"
  end
end

def create_admins(array, plantarray, unsplashurlarray, usernum)
  array.each do |name|
    admin = User.new(
      name: name,
      password: "tester",
      email: "#{name}@test.com",
      remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s),
      latitude: 48.8651313,
      longitude: 2.3778106
    )
    file = File.open('app/assets/images/admin-icon.png')
    admin.photo.attach(io: file, filename: 'admin-icon.jpeg', content_type: 'image/jpeg')
    admin.save!
    user_protocol(admin, plantarray, unsplashurlarray)
    usernum += 1
    puts "users created: #{usernum}"
  end
end

# puts "creating admins..."
# create_admins(["tristan", "charles", "benjamin", "pierre"], plantarray, unsplashurlarray, usernum)
# puts 'done!'

puts "creating regular users..."

24.times do
  user = User.new(
    name: Faker::Artist.name,
    password: Faker::Internet.password,
    remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s),
    longitude: rand(-1.35..12),
    latitude: rand(44.4..49.2)
    )
  user.email = Faker::Internet.email(name: user.name)
  attach_user_icon(user, userurlarray)
  user.save!
  usernum += 1
  puts "users created: #{usernum}"
end

puts "done!"
puts "creating plant owners..."

3.times do
  user = User.new(
    name: Faker::GreekPhilosophers.name,
    password: Faker::Internet.password,
    remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s),
    longitude: rand(-1.35..12),
    latitude: rand(44.4..49.2)
    )
  user.email = Faker::Internet.email(name: user.name)
  attach_user_icon(user, userurlarray)
  user.save!
  user_protocol(user, plantarray, unsplashurlarray)
  usernum += 1
  puts "users created: #{usernum}"
end

puts "creating tristan's demo account..."
create_demo_accounts(["tristan_mahe"], plantarray, unsplashurlarray, usernum)
puts "done!"

9.times do
  user = User.new(
    name: Faker::GreekPhilosophers.name,
    password: Faker::Internet.password,
    remember_created_at: Faker::Date.between(from: '2018-09-23', to: DateTime.now.to_date.to_s),
    longitude: rand(-1.35..12),
    latitude: rand(44.4..49.2)
    )
  user.email = Faker::Internet.email(name: user.name)
  attach_user_icon(user, userurlarray)
  user.save!
  user_protocol(user, plantarray, unsplashurlarray)
  usernum += 1
  puts "users created: #{usernum}"
end

puts "done!"

puts 'SUCCESS'

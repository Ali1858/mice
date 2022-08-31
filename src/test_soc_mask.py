from masker import SOCMasker
def test_merge_subtokens():
  tokens = ['<s>', 'Res','pects', 'Ġon','Ġthe','ĠU','pt','of','Ġthe','ĠI', 'Ġgood','with','the','Ġpeople','of','ĠWest','ĠBengal','.','ĠWatch','Ġmy','Ġspeed','.','ĉ','</s>']
  new_tokens,tokens_idx = SOCMasker.merge_subtokens(tokens)
  assert new_tokens == ['<s>','Respects','Ġon','Ġthe','ĠUptof','Ġthe','ĠI','Ġgoodwiththe','Ġpeopleof','ĠWest','ĠBengal.','ĠWatch','Ġmy','Ġspeed.','ĉ','</s>']
  assert tokens_idx == [[0],[1, 2],[3],[4],[5, 6, 7],[8],[9],[10, 11, 12],[13, 14],[15],[16, 17],[18],[19],[20, 21],[22],[23]]

  tokens = ['<s>','ive','Ġbeen','Ġknown','Ġto','Ġlook','Ġat','Ġ2',',','Ġeven','Ġ3','Ġemails','Ġ,','Ġat','Ġthe','Ġsame','Ġdamn','Ġtime','ĉ','</s>']
  new_tokens,tokens_idx = SOCMasker.merge_subtokens(tokens)
  assert new_tokens == ['<s>','ive','Ġbeen','Ġknown','Ġto','Ġlook','Ġat','Ġ2,','Ġeven','Ġ3','Ġemails','Ġ,','Ġat','Ġthe','Ġsame','Ġdamn','Ġtime','ĉ','</s>']
  assert tokens_idx == [[0],[1],[2],[3],[4],[5],[6],[7,8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19]]

  tokens = ['<s>','Kansas','ĠThey','Ġall','Ġsaid',',','ĠâĢ','ľ','I','Ġdon','âĢ','Ļ','t','Ġneed','Ġanything','.','ĠThey','Ġhad','Ġa','Ġhorrible','Ġcountry',',','Ġand','Ġhas','Ġthe','Ġspecial','Ġinfrastructure',',','Ġour','Ġcountry','Ġneeds','Ġa','Ġrich','.','ĉ','</s>']
  new_tokens,tokens_idx = SOCMasker.merge_subtokens(tokens)
  assert new_tokens == ['<s>','Kansas','ĠThey','Ġall','Ġsaid,','ĠâĢľI','ĠdonâĢĻt','Ġneed','Ġanything.','ĠThey','Ġhad','Ġa','Ġhorrible','Ġcountry,','Ġand','Ġhas','Ġthe','Ġspecial','Ġinfrastructure,','Ġour','Ġcountry','Ġneeds','Ġa','Ġrich.','ĉ','</s>']
  assert tokens_idx == [[0],[1],[2],[3],[4,5],[6,7,8],[9,10,11,12],[13],[14,15],[16],[17],[18],[19],[20,21],[22],[23],[24],[25],[26,27],[28],[29],[30],[31],[32,33],[34],[35]]

  tokens = ['<s>','H','ated','Ġit','Ġwith','Ġall','Ġmy','Ġbeing','.','ĠWorst','Ġmovie','Ġever','.','ĠMent','ally','-','Ġscar','red','.','ĠHelp','Ġme','.','ĠIt','Ġwas','Ġthat','Ġbad','.','TR','UST','ĠME','!!!','</s>']
  new_tokens,tokens_idx = SOCMasker.merge_subtokens(tokens)
  assert new_tokens == ['<s>','Hated','Ġit','Ġwith','Ġall','Ġmy','Ġbeing.','ĠWorst','Ġmovie','Ġever.','ĠMentally-','Ġscarred.','ĠHelp','Ġme.','ĠIt','Ġwas','Ġthat','Ġbad.TRUST','ĠME!!!','</s>']
  assert tokens_idx == [[0],[1,2],[3],[4],[5],[6],[7,8],[9],[10],[11,12],[13,14,15],[16,17,18],[19],[20,21],[22],[23],[24],[25,26,27,28],[29,30],[31]]

# test_merge_subtokens()
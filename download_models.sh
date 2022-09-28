for TASK in imdb newsgroups tweepfake
do	
	if task == "imdb" || task == "newsgroups"
	then
		mkdir -p trained_predictors/${TASK}/model
		mkdir -p results/${TASK}/editors/mice/
		wget https://storage.googleapis.com/allennlp-public-models/mice-${TASK}-predictor.tar.gz -O trained_predictors/${TASK}/model/model.tar.gz
		wget https://storage.googleapis.com/mice_model/stage1/${TASK}/soc/best.pth -O results/${TASK}/editors/mice/${TASK}_editor.pth 
	
	else
		mkdir -p trained_predictors/${TASK}/model
		mkdir -p results/${TASK}/editors/mice/
		wget https://storage.googleapis.com/mice_model/predictor/faketweep/model.tar.gz -O trained_predictors/${TASK}/model/model.tar.gz	
		wget https://storage.googleapis.com/mice_model/stage1/faketweep/soc/best.pth -O results/${TASK}/editors/mice/${TASK}_editor.pth  
	fi
done

		


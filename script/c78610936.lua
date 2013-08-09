--Xyz Encore
function c78610936.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c78610936.target)
	e1:SetOperation(c78610936.activate)
	c:RegisterEffect(e1)
end
function c78610936.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToExtra() and c:GetOverlayCount()>0
end
function c78610936.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c78610936.filter(chk) end
	if chk==0 then return Duel.IsExistingTarget(c78610936.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c78610936.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(c78610936.chlimit)
end
function c78610936.chlimit(e,ep,tp)
	return tp==ep
end
function c78610936.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c78610936.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetOverlayGroup()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft>0 and mg:GetCount()>0 then
			if mg:GetCount()>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				mg=mg:Select(tp,ft,ft,nil)
			end
			local tc=mg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(-1)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				tc=mg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end

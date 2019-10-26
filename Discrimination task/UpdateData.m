function Data = UpdateData(Data, delta, correctness, anstime, condition, order)  

s = condition;

Data.Data.PerCondition.StimVals{s} = [Data.Data.PerCondition.StimVals{s}; delta];
Data.Data.PerCondition.Responses{s} = [Data.Data.PerCondition.Responses{s}; correctness];
Data.Data.PerCondition.Orders{s} = [Data.Data.PerCondition.Orders{s}; order];
Data.Data.PerCondition.RTs{s} = [Data.Data.PerCondition.RTs{s}; anstime];

Data.Data.Running.Condition = [Data.Data.Running.Condition;s];
Data.Data.Running.StimVals = [Data.Data.Running.StimVals; delta];
Data.Data.Running.Responses = [Data.Data.Running.Responses; correctness];
Data.Data.Running.Orders = [Data.Data.Running.Orders;order];
Data.Data.Running.RTs = [Data.Data.Running.RTs;anstime];


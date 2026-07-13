#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50953 "Minutes Setup"
{
    

    fields
    {
        field(1;"Min Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Quote No";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Quote Description";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Specify Month";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '` ,Jan,Feb,Mar,Apr,May,June,Jult,Aug,Sept,Oct,Nov,Dec';
            OptionMembers = "` ",Jan,Feb,Mar,Apr,May,June,Jult,Aug,Sept,Oct,Nov,Dec;
        }
    }

    keys
    {
        key(Key1;"Min Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Min Code"='' then begin
          PurchasesPayablesSetup.Get;
        PurchasesPayablesSetup.TestField("Minutes Nos");

        Year:=Date2dmy(Today,3);
          if "Specify Month"<>"specify month"::"` " then begin

                            if Confirm('Do you wish to backdate this minute?')= true then

                            "Min Code":=('MIN/'+Format("Specify Month")+'/'+Format(Year)+'/'+NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Minutes Nos",Today,true));
                            end else


        if Date2dmy(Today,2)=1 then
          month:='JAN'else
          if Date2dmy(Today,2)=2 then
            month:='FEB' else
            if Date2dmy(Today,2)=3 then
              month:='MAR' else
        if Date2dmy(Today,2)=4 then
              month:='APR'else
          if Date2dmy(Today,2)=5 then
              month:='MAY'else
            if Date2dmy(Today,2)=6 then
              month:='JUN'else
              if Date2dmy(Today,2)=7 then
              month:='JUL'else
                if Date2dmy(Today,2)=8 then
              month:='AUG'else
                  if Date2dmy(Today,2)=9 then
              month:='SEP'else
                    if Date2dmy(Today,2)=10 then
              month:='OCT'else
                      if Date2dmy(Today,2)=11 then
              month:='NOV'else
                        if Date2dmy(Today,2)=12 then
              month:='DEC';
                        "Min Code":=('MIN/'+month+'/'+Format(Year)+'/'+NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Minutes Nos",Today,true));
                            end


    end;

    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        month: Text;
        Year: Integer;
}


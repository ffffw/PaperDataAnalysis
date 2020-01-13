c_a=Bch_RS_encoder(msg_a);
alice=bitxor(c_a,key_a);

bob=alice;
c_b=bitxor(bob,key_b);
msg_b=Bch_RS_decoder(c_b,length(msg_a));

eve=alice;
c_e=bitxor(eve,key_e);
msg_e=Bch_RS_decoder(c_e,length(msg_a));


ber_ab=length(find(msg_a~=msg_b))/length(msg_a);
ber_ae=length(find(msg_a~=msg_e))/length(msg_a);
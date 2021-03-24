for assr in \
GenFac_HWZ-x-141355-x-141355-x-gf-edat-Oddball_v2-x-92029131-6cfe-4608-b544-0d2ef68cac86 \
GenFac_HWZ-x-141355-x-141355-x-gf-edat-Oddball_v2-x-f0191f5b-21b0-41c0-bdd4-59f5e3768db2 \
GenFac_HWZ-x-141375-x-141375-x-gf-edat-Oddball_v2-x-b2329155-c237-4693-8023-c17a43282b36 \
GenFac_HWZ-x-141375-x-141375-x-gf-edat-Oddball_v2-x-e03f556f-70ca-4f84-b3c1-eb94c6204ce3 \
GenFac_HWZ-x-141382-x-141382-x-gf-edat-Oddball_v2-x-8a5d7155-d48e-4308-a129-05e6180ffcdc \
GenFac_HWZ-x-141382-x-141382-x-gf-edat-Oddball_v2-x-ac88f6b7-6216-4035-901a-5888c15a5c76 \
GenFac_HWZ-x-141394-x-141394-x-gf-edat-Oddball_v2-x-63b5d56d-028c-4775-a7e2-5899368ffdee \
GenFac_HWZ-x-141394-x-141394-x-gf-edat-Oddball_v2-x-a6c857e6-5676-4c67-80e0-e721cc98d9ff \
GenFac_HWZ-x-141421-x-141421-x-gf-edat-Oddball_v2-x-1b620557-b29a-4961-8ce1-ef92912d4ea4 \
GenFac_HWZ-x-141421-x-141421-x-gf-edat-Oddball_v2-x-8c397bcf-9f65-4b4c-bfcf-bd12d56f25db \
GenFac_HWZ-x-141423-x-141423-x-gf-edat-Oddball_v2-x-19a7045e-865c-47a0-acce-73424d7cb01b \
GenFac_HWZ-x-141427-x-141427-x-gf-edat-Oddball_v2-x-e03e211b-097a-44ab-934b-bb81397cdd3a \
GenFac_HWZ-x-141429-x-141429-x-gf-edat-Oddball_v2-x-5b8347ae-4054-4ebb-a4b8-4a28d1ec3a88 \
GenFac_HWZ-x-141429-x-141429-x-gf-edat-Oddball_v2-x-71f5bb34-e2a9-4413-ab70-7ff3dd8939a6 \
GenFac_HWZ-x-141568-x-141568-x-gf-edat-Oddball_v2-x-4ed9e2cd-9d8a-4539-afeb-b68f5668fa96 \
GenFac_HWZ-x-141568-x-141568-x-gf-edat-Oddball_v2-x-b0b31df6-3c9b-479a-ae88-276742a2d1f0 \
GenFac_HWZ-x-141582-x-141582-x-gf-edat-Oddball_v2-x-009f9564-9033-4bd4-b39f-60e55384fcba \
GenFac_HWZ-x-141582-x-141582-x-gf-edat-Oddball_v2-x-d37d0b21-177c-4917-bb7e-b4a64fac99bb \
GenFac_HWZ-x-141620-x-141620-x-gf-edat-Oddball_v2-x-8eddba87-1f34-44b6-80c4-4c24d3f6f985 \
GenFac_HWZ-x-141620-x-141620-x-gf-edat-Oddball_v2-x-aa8602d0-f352-49b0-ba14-63ca521a4dcb
do
	XnatSwitchProcessStatus --select $assr --qc -s "Old eprime version"
done

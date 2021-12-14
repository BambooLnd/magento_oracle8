 sed -i '/keyfile=\|certfile=/d' /etc/webmin/miniserv.conf
 echo "keyfile=/etc/letsencrypt/live/${MAGE_DOMAIN}/privkey.pem" >> /etc/webmin/miniserv.conf
 echo "certfile=/etc/letsencrypt/live/${MAGE_DOMAIN}/cert.pem" >> /etc/webmin/miniserv.conf
 
  if [ -f "/usr/local/csf/csfwebmin.tgz" ]; then
    perl /usr/${WEBMINEXEC}/webmin/install-module.pl /usr/local/csf/csfwebmin.tgz >/dev/null 2>&1
    GREENTXT "INSTALLED CSF FIREWALL PLUGIN"
  fi
  
  echo "${MAGE_OWNER}_webmin:\$1\$84720675\$F08uAAcIMcN8lZNg9D74p1:::::$(date +%s):::0::::" > /etc/webmin/miniserv.users
  sed -i "s/root:/${MAGE_OWNER}_webmin:/" /etc/webmin/webmin.acl
  WEBMIN_PASS=$(head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9@#%^?=+_[]{}()<>-' | fold -w 15 | head -n 1)
  /usr/${WEBMINEXEC}/webmin/changepass.pl /etc/webmin/ ${MAGE_OWNER}_webmin "${WEBMIN_PASS}"
  
  systemctl enable webmin
  /etc/webmin/restart

  echo
  GREENTXT "WEBMIN INSTALLED - OK"
  echo
  YELLOWTXT "[!] WEBMIN PORT: ${WEBMIN_PORT}"
  YELLOWTXT "[!] USER: ${MAGE_OWNER}_webmin"
  YELLOWTXT "[!] PASSWORD: ${WEBMIN_PASS}"
  REDTXT "[!] PLEASE ENABLE TWO-FACTOR AUTHENTICATION!"
	    
cat > ${MAGENX_CONFIG_PATH}/webmin <<END
WEBMIN_PORT="${WEBMIN_PORT}"
WEBMIN_USER="${MAGE_OWNER}_webmin"
WEBMIN_PASS="${WEBMIN_PASS}"
END
  else
   echo
   REDTXT "WEBMIN INSTALLATION ERROR"
  fi
  else
   echo
   YELLOWTXT "Webmin installation was skipped by the user. Next step"
fi
echo
echo
pause '[] Press [Enter] key to show menu'
echo
;;
"exit")
REDTXT "[!] EXIT"
exit
;;

###################################################################################
###                             CATCH ALL MENU - THE END                        ###
###################################################################################

*)
printf "\033c"
;;
esac
done


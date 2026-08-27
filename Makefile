# ============================================================
#  VARIABLES
# ============================================================

USER		:= spacotto
NAME		:= inception
ENV		:= srcs/.env
COMPOSE_FILE	:= ./srcs/docker-compose.yml
COMPOSE		:= docker compose -f $(COMPOSE_FILE) --env-file $(ENV)

# ------------------------------------------------------------
#  General Variables
# ------------------------------------------------------------

ECHO     := echo 
FIND     := /bin/find
IGNORE   := 2>/dev/null || true
MV       := /bin/mv
MKDIR    := mkdir -p
SUDO     := sudo

# ------------------------------------------------------------
#  Ansi Colors
# ------------------------------------------------------------

RESET    := \033[0m
GRAY     := \033[1;90m
RED      := \033[1;91m
GREEN    := \033[1;92m
YELLOW   := \033[1;93m
BLUE     := \033[1;94m
MAGENTA  := \033[1;95m
CYAN     := \033[1;96m
WHITE    := \033[1;97m

# ============================================================
#  RULES
# ============================================================

.PHONY: all setup build down re clean fclean reset help

# ------------------------------------------------------------
#  all — default target
# ------------------------------------------------------------

all: setup build
	@$(ECHO) ">>> $(YELLOW)Launching $(NAME)...$(RESET)"
	@$(ECHO) ">>> $(CYAN)Done.$(RESET)"

# ------------------------------------------------------------
#  setup — configure host machine (directories and /etc/hosts)
# ------------------------------------------------------------

setup:
	@$(ECHO) ">>> $(YELLOW)Setting up host environment for $(USER)...$(RESET)"
	@$(SUDO) $(MKDIR) /home/$(USER)/data/mariadb
	@$(SUDO) $(MKDIR) /home/$(USER)/data/wordpress
	@if ! grep -q "$(USER).42.fr" /etc/hosts; then \
		$(SUDO) sh -c 'echo "127.0.0.1\t$(USER).42.fr" >> /etc/hosts'; \
		$(ECHO) ">>> $(GREEN)Added $(USER).42.fr to /etc/hosts$(RESET)"; \
	fi
	@$(ECHO) ">>> $(CYAN)Done.$(RESET)"

# ------------------------------------------------------------
#  build — build and launch configuration
# ------------------------------------------------------------

build:
	@$(ECHO) ">>> $(YELLOW)Building configuration $(NAME)...$(RESET)"
	@$(COMPOSE) up -d --build
	@$(ECHO) ">>> $(CYAN)Done.$(RESET)"

# ------------------------------------------------------------
#  down — stop and remove containers
# ------------------------------------------------------------

down:
	@$(ECHO) ">>> $(YELLOW)Stopping configuration $(NAME)...$(RESET)"
	@$(COMPOSE) down
	@$(ECHO) ">>> $(CYAN)Done.$(RESET)"

# ------------------------------------------------------------
#  re — restart and rebuild configuration
# ------------------------------------------------------------

re: fclean all
	@$(ECHO) ">>> $(CYAN)Restarted and rebuilt everything.$(RESET)"

# ------------------------------------------------------------
#  clean — clean all docker images and containers
# ------------------------------------------------------------

clean: down
	@$(ECHO) ">>> $(YELLOW)Cleaning configuration $(NAME)...$(RESET)"
	@docker system prune -a
	@$(ECHO) ">>> $(CYAN)Done.$(RESET)"

# ------------------------------------------------------------
#  fclean — deep clean of all docker data (volumes, networks, etc)
# ------------------------------------------------------------

fclean:
	@$(ECHO) ">>> $(YELLOW)Total clean of all docker configurations...$(RESET)"
	@$(COMPOSE) down -v --rmi local
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@$(SUDO) rm -rf /home/$(USER)/data/*
	@$(ECHO) ">>> $(CYAN)Done.$(RESET)"

# ------------------------------------------------------------
#  reset — wipe all docker data and host volumes
# ------------------------------------------------------------

reset:
	@$(ECHO) ">>> $(YELLOW)Resetting environment completely...$(RESET)"
	@docker stop $$(docker ps -qa) $(IGNORE)
	@docker rm $$(docker ps -qa) $(IGNORE)
	@docker rmi -f $$(docker images -qa) $(IGNORE)
	@docker volume rm $$(docker volume ls -q) $(IGNORE)
	@docker network rm $$(docker network ls -q) $(IGNORE)
	@$(SUDO) rm -rf /home/$(USER)/data/*
	@$(ECHO) ">>> $(CYAN)Environment reset.$(RESET)"

# ------------------------------------------------------------
#  help — show available rules
# ------------------------------------------------------------

help:
	@$(ECHO) ""
	@$(ECHO) " $(CYAN)AVAILABLE RULES$(RESET)"
	@$(ECHO) ""
	@$(ECHO) "     $(CYAN)all$(RESET)        	Launch configuration"
	@$(ECHO) "     $(CYAN)build$(RESET)      	Build and launch configuration"
	@$(ECHO) "     $(CYAN)down$(RESET)       	Stop and remove containers"
	@$(ECHO) "     $(CYAN)re$(RESET)         	Restart and rebuild configuration"
	@$(ECHO) "     $(CYAN)clean$(RESET)      	Clean all docker images and containers"
	@$(ECHO) "     $(CYAN)fclean$(RESET)     	Deep clean of all docker data"
	@$(ECHO) "     $(CYAN)reset$(RESET)      	Wipe all docker data and host volumes"
	@$(ECHO) "     $(CYAN)help$(RESET)       	Show available rules"
	@$(ECHO) ""
